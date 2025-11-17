//
//  MusicVideoDetailView.swift
//  main
//
//  Created by iTunes Store MVP
//

import SwiftUI

struct MusicVideoDetailView: View {
    let videoId: String
    @StateObject private var viewModel = MusicVideoDetailViewModel()
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 100)
            } else if let video = viewModel.musicVideo {
                VStack(spacing: 0) {
                    // Video preview with blur background
                    ZStack {
                        // Blur background
                        if let imageName = video.previewImageURL {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 300)
                                .clipped()
                                .blur(radius: 50)
                                .opacity(0.3)
                        }
                        
                        // Main video preview
                        VStack(spacing: 16) {
                            if let imageName = video.previewImageURL {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(16/9, contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                                    .padding(.horizontal, 24)
                            }
                            
                            // Play button (visual only)
                            Button(action: {}) {
                                HStack(spacing: 8) {
                                    Image(systemName: "play.fill")
                                    Text("Play")
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .cornerRadius(25)
                            }
                        }
                        .padding(.vertical, 24)
                    }
                    .frame(height: 300)
                    
                    // Video metadata
                    VStack(alignment: .leading, spacing: 16) {
                        // Title and artist
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(video.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                if video.explicit {
                                    ExplicitComponent()
                                }
                            }
                            
                            Text(video.artistName)
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        // Metadata grid
                        VStack(alignment: .leading, spacing: 12) {
                            MetadataRow(label: "Duration", value: video.durationFormatted)
                            
                            if let genre = video.genre {
                                MetadataRow(label: "Genre", value: genre)
                            }
                            
                            if let releaseDate = video.releaseDateFormatted {
                                MetadataRow(label: "Released", value: releaseDate)
                            }
                            
                            if let viewCount = video.viewCount {
                                MetadataRow(label: "Views", value: video.viewCountFormatted)
                            }
                        }
                        
                        // Related videos section
                        if !viewModel.relatedVideos.isEmpty {
                            Divider()
                                .padding(.top, 8)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Related Videos")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(viewModel.relatedVideos) { relatedVideo in
                                            NavigationLink(value: relatedVideo) {
                                                MusicVideoCard(musicVideo: relatedVideo, size: 140)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(24)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMusicVideo(videoId: videoId)
        }
    }
}

// Helper view for metadata rows
struct MetadataRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}

#Preview {
    NavigationStack {
        MusicVideoDetailView(videoId: "mv1")
    }
}

