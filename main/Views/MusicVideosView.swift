//
//  MusicVideosView.swift
//  main
//
//  Created by iTunes Store MVP
//

import SwiftUI

struct MusicVideosView: View {
    @StateObject private var viewModel = MusicVideosViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading && viewModel.musicVideos.isEmpty {
                    // Loading state
                    ProgressView()
                        .padding(.top, 100)
                } else if let errorMessage = viewModel.errorMessage {
                    // Error state
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text(errorMessage)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 100)
                } else {
                    // Grid content
                    LazyVGrid(columns: GridLayouts.twoColumnGrid, spacing: GridSpacing.verticalSpacing) {
                        ForEach(viewModel.musicVideos) { video in
                            NavigationLink(value: video) {
                                MusicVideoCard(musicVideo: video)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, GridSpacing.horizontalPadding)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Music Videos")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: MusicVideo.self) { video in
                MusicVideoDetailView(videoId: video.id)
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}

#Preview {
    MusicVideosView()
}

