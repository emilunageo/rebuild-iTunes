//
//  FullPlayerView.swift
//  main
//
//  Created by Emiliano Luna George on 16/11/25.
//

import SwiftUI

struct FullPlayerView: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background with blur
            if let song = playerViewModel.currentSong {
                Image(song.album.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .blur(radius: 100)
                    .opacity(0.3)
            }
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                if let song = playerViewModel.currentSong {
                    // Album artwork
                    Image(song.album.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 320, maxHeight: 320)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // Song info
                    VStack(spacing: 8) {
                        HStack {
                            Text(song.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .lineLimit(1)
                            
                            if song.explicit {
                                ExplicitComponent()
                            }
                        }
                        
                        Text(song.artistNames)
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Progress slider
                    VStack(spacing: 8) {
                        Slider(
                            value: Binding(
                                get: { playerViewModel.currentTime },
                                set: { playerViewModel.seek(to: $0) }
                            ),
                            in: 0...max(playerViewModel.duration, 1)
                        )
                        .tint(.accentColor)
                        
                        HStack {
                            Text(playerViewModel.currentTimeFormatted)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .monospacedDigit()
                            
                            Spacer()
                            
                            Text(playerViewModel.durationFormatted)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .monospacedDigit()
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    // Controls
                    HStack(spacing: 40) {
                        Button {
                            // Previous track (not implemented in MVP)
                        } label: {
                            Image(systemName: "backward.fill")
                                .font(.title)
                                .foregroundColor(.secondary)
                        }
                        .disabled(true)
                        
                        Button {
                            playerViewModel.togglePlayPause()
                        } label: {
                            Image(systemName: playerViewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 64))
                                .foregroundColor(.primary)
                        }
                        
                        Button {
                            // Next track (not implemented in MVP)
                        } label: {
                            Image(systemName: "forward.fill")
                                .font(.title)
                                .foregroundColor(.secondary)
                        }
                        .disabled(true)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

#Preview {
    FullPlayerView()
        .environmentObject({
            let vm = PlayerViewModel.shared
            vm.currentSong = Song(
                id: "1",
                name: "Midnight Dreams",
                artists: [Artist(id: "1", name: "Nsqk")],
                album: Album(artistName: "Nsqk", albumName: "ATP", imageName: "atp", isExplicit: true),
                durationMs: 234000,
                explicit: true
            )
            return vm
        }())
}

