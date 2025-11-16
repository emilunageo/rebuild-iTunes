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
    
    private let apiService = MockAPIService.shared
    
    func loadSongDetails(songId: String) async {
        isLoading = true
        
        song = await apiService.fetchSongDetails(songId: songId)
        
        if let albumId = song?.album.id {
            albumTracks = await apiService.fetchAlbumTracks(albumId: albumId)
        }
        
        isLoading = false
    }
    
    func loadAlbumDetails(albumId: String) async {
        isLoading = true
        
        albumTracks = await apiService.fetchAlbumTracks(albumId: albumId)
        song = albumTracks.first
        
        isLoading = false
    }
}

