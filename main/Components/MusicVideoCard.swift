//
//  MusicVideoCard.swift
//  main
//
//  Created by iTunes Store MVP
//

import SwiftUI

struct MusicVideoCard: View {
    let musicVideo: MusicVideo
    let size: CGFloat
    
    init(musicVideo: MusicVideo, size: CGFloat = 160) {
        self.musicVideo = musicVideo
        self.size = size
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Video thumbnail with play overlay
            ZStack(alignment: .bottomTrailing) {
                // Thumbnail image
                if let imageName = musicVideo.previewImageURL {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fill)
                        .frame(width: size, height: size * GridCardSize.video)
                        .clipped()
                        .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(16/9, contentMode: .fill)
                        .frame(width: size, height: size * GridCardSize.video)
                        .cornerRadius(8)
                        .overlay(
                            Image(systemName: "video.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white.opacity(0.6))
                        )
                }
                
                // Play icon overlay
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    .padding(8)
                
                // Duration badge
                Text(musicVideo.durationFormatted)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(4)
                    .padding([.leading, .bottom], 8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            
            // Video info
            VStack(alignment: .leading, spacing: 4) {
                Text(musicVideo.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(musicVideo.artistName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                if musicVideo.explicit {
                    ExplicitComponent()
                }
            }
            .frame(width: size, alignment: .leading)
        }
        .frame(width: size)
    }
}

#Preview {
    MusicVideoCard(
        musicVideo: MusicVideo(
            id: "1",
            title: "Midnight Dreams",
            artist: Artist(id: "1", name: "Nsqk", images: nil),
            previewImageURL: "atp",
            durationMs: 234000,
            explicit: true,
            genre: "Electronic",
            releaseDate: "2024-03-15",
            viewCount: 2_450_000
        )
    )
    .padding()
}

