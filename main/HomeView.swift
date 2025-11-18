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

    // Mock price generator for grid items
    private func mockPrice(for index: Int) -> String {
        let prices = ["$0.99", "$1.29", "$0.99", "$1.29", "$0.99", "$1.29", "$0.99", "$1.29"]
        return prices[index % prices.count]
    }

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

                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 16),
                                    GridItem(.flexible(), spacing: 16)
                                ],
                                spacing: 20
                            ) {
                                ForEach(Array(viewModel.topSongs.enumerated()), id: \.element.id) { index, song in
                                    Button {
                                        playerViewModel.playSong(song)
                                    } label: {
                                        SongGridItem(
                                            song: song,
                                            price: mockPrice(for: index),
                                            isPlaying: playerViewModel.currentSong?.id == song.id && playerViewModel.isPlaying
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
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
            .alert("Preview Unavailable", isPresented: $playerViewModel.showError) {
                Button("OK", role: .cancel) {
                    playerViewModel.showError = false
                }
            } message: {
                Text(playerViewModel.errorMessage ?? "This track doesn't have a preview available.")
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(PlayerViewModel.shared)
}
