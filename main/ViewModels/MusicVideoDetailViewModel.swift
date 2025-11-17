//
//  MusicVideoDetailViewModel.swift
//  main
//
//  Created by iTunes Store MVP
//

import Foundation
import Combine

@MainActor
class MusicVideoDetailViewModel: ObservableObject {
    @Published var musicVideo: MusicVideo?
    @Published var relatedVideos: [MusicVideo] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let apiService = MockAPIService.shared
    
    /// Load music video details and related videos
    func loadMusicVideo(videoId: String) async {
        isLoading = true
        errorMessage = nil
        
        async let videoTask = apiService.fetchMusicVideoDetails(videoId: videoId)
        async let relatedTask = apiService.fetchRelatedMusicVideos(videoId: videoId)
        
        do {
            musicVideo = await videoTask
            relatedVideos = await relatedTask
        } catch {
            errorMessage = "Failed to load music video details"
        }
        
        isLoading = false
    }
}

