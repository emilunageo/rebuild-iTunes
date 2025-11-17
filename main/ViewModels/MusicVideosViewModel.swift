//
//  MusicVideosViewModel.swift
//  main
//
//  Created by iTunes Store MVP
//

import Foundation
import Combine

@MainActor
class MusicVideosViewModel: ObservableObject {
    @Published var musicVideos: [MusicVideo] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let apiService = MockAPIService.shared
    
    init() {
        Task {
            await loadMusicVideos()
        }
    }
    
    /// Load all music videos
    func loadMusicVideos() async {
        isLoading = true
        errorMessage = nil
        
        do {
            musicVideos = await apiService.fetchMusicVideos()
        } catch {
            errorMessage = "Failed to load music videos"
        }
        
        isLoading = false
    }
    
    /// Refresh music videos (for pull-to-refresh)
    func refresh() async {
        await loadMusicVideos()
    }
}

