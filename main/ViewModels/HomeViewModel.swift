//
//  HomeViewModel.swift
//  main
//
//  Created by Emiliano Luna George on 16/11/25.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var newReleases: [Album] = []
    @Published var trendingAlbums: [Album] = []
    @Published var topSongs: [Song] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = MockAPIService.shared
    
    func loadContent() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let releases = apiService.fetchNewReleases()
            async let trending = apiService.fetchTrendingAlbums()
            async let topTracks = apiService.fetchTopSongs()
            
            let (fetchedReleases, fetchedTrending, fetchedTopTracks) = await (releases, trending, topTracks)
            
            newReleases = fetchedReleases
            trendingAlbums = fetchedTrending
            topSongs = fetchedTopTracks
        } catch {
            errorMessage = "Failed to load content: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

