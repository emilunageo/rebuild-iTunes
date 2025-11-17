//
//  SongDetailViewModel.swift
//  main
//
//  Created by Emiliano Luna George on 16/11/25.
//

import Foundation
import Combine

@MainActor
class SongDetailViewModel: ObservableObject {
    @Published var song: Song?
    @Published var albumTracks: [Song] = []
    @Published var isLoading = false

    // Use Spotify API instead of Mock API
    private let apiService = SpotifyAPIService.shared

    func loadSongDetails(songId: String) async {
        isLoading = true

        do {
            // Note: Spotify API doesn't have a direct "get track" endpoint in our current implementation
            // We'll need to fetch the album and find the track
            // For now, we'll skip this method as it's not commonly used
            print("loadSongDetails not fully implemented for Spotify API")
        } catch {
            print("Error loading song details: \(error)")
        }

        isLoading = false
    }

    func loadAlbumDetails(albumId: String) async {
        isLoading = true

        do {
            albumTracks = try await apiService.fetchAlbumTracks(albumId: albumId)
            song = albumTracks.first
        } catch {
            print("Error loading album details: \(error)")
        }

        isLoading = false
    }
}

