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
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    func playSong(_ song: Song) {
        // Stop current playback
        stop()

        currentSong = song
        errorMessage = nil

        // Try to play from Spotify preview URL
        if let previewURLString = song.previewUrl,
           let previewURL = URL(string: previewURLString) {
            playFromURL(previewURL)
        } else {
            // Fallback to local preview file if no Spotify preview available
            if let localURL = Bundle.main.url(forResource: "preview", withExtension: "mp3") {
                playFromURL(localURL)
            } else {
                errorMessage = "No preview available for this track"
                print("No preview URL available for song: \(song.name)")
            }
        }
    }

    private func playFromURL(_ url: URL) {
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

        play()
    }

    private func handlePlayerStatus(_ status: AVPlayerItem.Status) {
        switch status {
        case .readyToPlay:
            if let duration = player?.currentItem?.duration {
                self.duration = CMTimeGetSeconds(duration)
            }
        case .failed:
            errorMessage = "Failed to load audio"
            print("Player failed: \(player?.currentItem?.error?.localizedDescription ?? "Unknown error")")
        case .unknown:
            break
        @unknown default:
            break
        }
    }

    private func updateProgress(_ time: CMTime) {
        currentTime = CMTimeGetSeconds(time)
    }
    
    func play() {
        player?.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func togglePlayPause() {
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

