//
//  SearchView.swift
//  main
//
//  Created by Emiliano Luna George on 16/11/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject var playerViewModel: PlayerViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let results = viewModel.searchResults {
                        if results.isEmpty {
                            emptyResultsView
                        } else {
                            searchResultsView(results)
                        }
                    } else if !viewModel.searchQuery.isEmpty && viewModel.isSearching {
                        ProgressView()
                            .padding(.top, 100)
                    } else {
                        placeholderView
                    }
                }
                .padding(.bottom, 100) // Space for mini player
            }
            .navigationTitle("Search")
            .searchable(
                text: $viewModel.searchQuery,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Songs, albums, or artists"
            )
        }
    }
    
    private var placeholderView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("Search for Music")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Find your favorite songs, albums, and artists")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .padding(.top, 100)
    }
    
    private var emptyResultsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "music.note.list")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Results Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Try searching for something else")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .padding(.top, 100)
    }
    
    private func searchResultsView(_ results: SearchResults) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            // Songs
            if !results.songs.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Songs")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ForEach(results.songs) { song in
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
            
            // Albums
            if !results.albums.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Albums")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(results.albums) { album in
                                NavigationLink(value: album) {
                                    AlbumCard(album: album)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            
            // Artists
            if !results.artists.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Artists")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ForEach(results.artists) { artist in
                        HStack {
                            Circle()
                                .fill(Color.secondary.opacity(0.3))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.secondary)
                                )
                            
                            Text(artist.name)
                                .font(.body)
                                .fontWeight(.medium)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationDestination(for: Album.self) { album in
            AlbumDetailView(album: album)
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(PlayerViewModel.shared)
}

