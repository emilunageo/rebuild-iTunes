//
//  PlayerViewModel.swift
//  main
//
//  Created by Emiliano Luna George on 16/11/25.
//

import Foundation
import AVFoundation
import Combine

@MainActor
class PlayerViewModel: ObservableObject {
    @Published var currentSong: Song?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var errorMessage: String?
    @Published var showError = false

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var statusObserver: NSKeyValueObservation?

    static let shared = PlayerViewModel()

    private init() {
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            print("✅ Audio session configured successfully")
        } catch {
            print("❌ Failed to set up audio session: \(error)")
            errorMessage = "Audio session setup failed: \(error.localizedDescription)"
        }
    }

    func playSong(_ song: Song) {
        // Stop current playback
        stop()

        currentSong = song
        errorMessage = nil
        showError = false

        // Debug logging
        print("\n🎵 ========================================")
        print("🎵 Attempting to play song: \(song.name)")
        print("   Artist: \(song.artistNames)")
        print("   Preview URL: \(song.previewUrl ?? "nil")")
        print("🎵 ========================================\n")

        // Try to play from Spotify preview URL
        if let previewURLString = song.previewUrl,
           !previewURLString.isEmpty,
           let previewURL = URL(string: previewURLString) {
            print("   ✅ Valid preview URL found, attempting playback...")
            playFromURL(previewURL)
        } else {
            // Fallback to local preview file if no Spotify preview available
            print("   ⚠️ No Spotify preview URL available")
            if let localURL = Bundle.main.url(forResource: "preview", withExtension: "mp3") {
                print("   ✅ Using local preview file")
                playFromURL(localURL)
            } else {
                let message = "Preview not available for '\(song.name)'. Spotify doesn't provide preview URLs for all tracks."
                errorMessage = message
                showError = true
                print("   ❌ ERROR: No preview URL and no local preview file found")
                print("   💡 Spotify often doesn't provide preview URLs for all tracks")
                print("   💡 This is a limitation of the Spotify Web API, not your app")
            }
        }
    }

    private func playFromURL(_ url: URL) {
        print("🎧 Setting up player with URL: \(url)")
        print("   URL scheme: \(url.scheme ?? "none")")
        print("   Is file URL: \(url.isFileURL)")

        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        // Observe player status
        statusObserver = playerItem.observe(\.status, options: [.new]) { [weak self] item, _ in
            Task { @MainActor in
                self?.handlePlayerStatus(item.status)
            }
        }

        // Observe playback time
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            Task { @MainActor in
                self?.updateProgress(time)
            }
        }

        // Observe when playback ends
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.stop()
            }
        }

        print("   ⏳ Waiting for player to be ready...")
        // Don't call play() here - wait for readyToPlay status
    }

    private func handlePlayerStatus(_ status: AVPlayerItem.Status) {
        switch status {
        case .readyToPlay:
            print("   ✅ Player ready to play!")
            if let duration = player?.currentItem?.duration {
                self.duration = CMTimeGetSeconds(duration)
                print("   Duration: \(formatTime(CMTimeGetSeconds(duration)))")
            }
            // Auto-play when ready
            if !isPlaying {
                print("   ▶️ Starting playback...")
                play()
            }
        case .failed:
            errorMessage = "Failed to load audio"
            let error = player?.currentItem?.error
            print("   ❌ Player FAILED!")
            print("   Error: \(error?.localizedDescription ?? "Unknown error")")
            if let nsError = error as NSError? {
                print("   Error domain: \(nsError.domain)")
                print("   Error code: \(nsError.code)")
                print("   Error userInfo: \(nsError.userInfo)")
            }
        case .unknown:
            print("   ⏳ Player status: unknown")
            break
        @unknown default:
            print("   ⚠️ Player status: @unknown default")
            break
        }
    }

    private func updateProgress(_ time: CMTime) {
        currentTime = CMTimeGetSeconds(time)
    }
    
    func play() {
        print("   ▶️ play() called")
        player?.play()
        isPlaying = true
        print("   Player rate: \(player?.rate ?? 0)")
    }

    func pause() {
        print("   ⏸️ pause() called")
        player?.pause()
        isPlaying = false
    }

    func togglePlayPause() {
        guard player != nil else { return }

        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func stop() {
        player?.pause()

        // Remove observers
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        statusObserver?.invalidate()
        statusObserver = nil

        NotificationCenter.default.removeObserver(self)

        player = nil
        isPlaying = false
        currentTime = 0
        duration = 0
    }

    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: cmTime)
        currentTime = time
    }
    
    var progress: Double {
        guard duration > 0 else { return 0 }
        return currentTime / duration
    }
    
    var currentTimeFormatted: String {
        formatTime(currentTime)
    }
    
    var durationFormatted: String {
        formatTime(duration)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

