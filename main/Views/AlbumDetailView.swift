//
//  AlbumDetailView.swift
//  main
//
//  Created by Emiliano Luna George on 16/11/25.
//

import SwiftUI

struct AlbumDetailView: View {
    let album: Album
    @StateObject private var viewModel = SongDetailViewModel()
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Album Header
                albumHeader
                
                // Track List
                VStack(alignment: .leading, spacing: 8) {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    } else {
                        ForEach(viewModel.albumTracks) { song in
                            Button {
                                playerViewModel.playSong(song)
                            } label: {
                                SongRow(
                                    song: song,
                                    showAlbumArt: false,
                                    isPlaying: playerViewModel.currentSong?.id == song.id && playerViewModel.isPlaying
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            if song.id != viewModel.albumTracks.last?.id {
                                Divider()
                                    .padding(.leading, 12)
                            }
                        }
                    }
                }
                .padding()
            }
            .padding(.bottom, 100) // Space for mini player
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadAlbumDetails(albumId: album.id)
        }
    }
    
    private var albumHeader: some View {
        VStack(spacing: 16) {
            // Album artwork with blur background
            ZStack {
                // Blurred background
                Image(album.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .blur(radius: 50)
                    .opacity(0.3)
                
                // Main artwork
                Image(album.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 220, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            
            // Album info
            VStack(spacing: 8) {
                Text(album.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(album.artistName)
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    if let releaseDate = album.releaseDate {
                        Text(String(releaseDate.prefix(4)))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let totalTracks = album.totalTracks {
                        Text("•")
                            .foregroundColor(.secondary)
                        Text("\(totalTracks) songs")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    NavigationStack {
        AlbumDetailView(
            album: Album(
                id: "1",
                name: "ATP",
                artists: [Artist(id: "1", name: "Nsqk")],
                images: [AlbumImage(url: "atp", height: 640, width: 640)],
                releaseDate: "2024-03-15",
                totalTracks: 12
            )
        )
        .environmentObject(PlayerViewModel.shared)
    }
}

