//
//  HomeView.swift
//  main
//
//  Created by Emiliano Luna George on 07/11/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var playerViewModel: PlayerViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.top, 100)
                    } else {
                        // New Releases
                        HorizontalCarousel(title: "New Releases", showSeeAll: true) {
                            ForEach(viewModel.newReleases) { album in
                                NavigationLink(value: album) {
                                    AlbumCard(album: album)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }

                        // Trending Albums
                        HorizontalCarousel(title: "Trending Now", showSeeAll: true) {
                            ForEach(viewModel.trendingAlbums) { album in
                                NavigationLink(value: album) {
                                    AlbumCard(album: album, size: 160)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }

                        // Top Songs
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Top Songs")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)

                            ForEach(viewModel.topSongs) { song in
                                Button {
                                    playerViewModel.playSong(song)
                                } label: {
                                    SongRow(
                                        song: song,
                                        isPlaying: playerViewModel.currentSong?.id == song.id && playerViewModel.isPlaying
                                    )
                                    .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding(.bottom, 100) // Space for mini player
            }
            .navigationTitle("Music")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Album.self) { album in
                AlbumDetailView(album: album)
            }
            .task {
                await viewModel.loadContent()
            }
            .refreshable {
                await viewModel.loadContent()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(PlayerViewModel.shared)
}
