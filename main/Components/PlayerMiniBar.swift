//
//  PlayerMiniBar.swift
//  main
//
//  Created by Emiliano Luna George on 16/11/25.
//

import SwiftUI

struct PlayerMiniBar: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State private var showFullPlayer = false
    
    var body: some View {
        if let song = playerViewModel.currentSong {
            VStack(spacing: 0) {
                // Progress bar
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(width: geometry.size.width * playerViewModel.progress)
                }
                .frame(height: 2)
                
                // Mini player content
                HStack(spacing: 12) {
                    // Album artwork
                    if let firstImage = song.album.images.first, let imageURL = URL(string: firstImage.url) {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .overlay(
                                        ProgressView()
                                            .scaleEffect(0.5)
                                    )
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            case .failure:
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .overlay(
                                        Image(systemName: "music.note")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white.opacity(0.6))
                                    )
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .overlay(
                                Image(systemName: "music.note")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white.opacity(0.6))
                            )
                    }
                    
                    // Song info
                    VStack(alignment: .leading, spacing: 2) {
                        Text(song.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        
                        Text(song.artistNames)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    // Play/Pause button
                    Button {
                        playerViewModel.togglePlayPause()
                    } label: {
                        Image(systemName: playerViewModel.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title3)
                            .foregroundColor(.primary)
                            .frame(width: 44, height: 44)
                    }
                    
                    // Stop button
                    Button {
                        withAnimation {
                            playerViewModel.stop()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(
                    .ultraThinMaterial,
                    in: Rectangle()
                )
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .onTapGesture {
                showFullPlayer = true
            }
            .sheet(isPresented: $showFullPlayer) {
                FullPlayerView()
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        PlayerMiniBar()
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
}

