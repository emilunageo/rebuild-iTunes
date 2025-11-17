//
//  SongGridItem.swift
//  main
//
//  Created by Emiliano Luna George
//

import SwiftUI

/// Song grid item component for grid layouts (iTunes Store style)
struct SongGridItem: View {
    let song: Song
    let price: String
    let isPlaying: Bool
    
    init(song: Song, price: String = "$0.99", isPlaying: Bool = false) {
        self.song = song
        self.price = price
        self.isPlaying = isPlaying
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Album artwork
            ZStack(alignment: .bottomTrailing) {
                if let firstImage = song.album.images.first, let imageURL = URL(string: firstImage.url) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .aspectRatio(1, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    ProgressView()
                                        .scaleEffect(0.8)
                                )
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(1, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .aspectRatio(1, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    Image(systemName: "music.note")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white.opacity(0.6))
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            Image(systemName: "music.note")
                                .font(.system(size: 30))
                                .foregroundColor(.white.opacity(0.6))
                        )
                }
                
                // Playing indicator overlay
                if isPlaying {
                    Image(systemName: "waveform.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.accentColor)
                        .background(
                            Circle()
                                .fill(Color(uiColor: .systemBackground))
                                .frame(width: 20, height: 20)
                        )
                        .padding(8)
                }
            }
            
            // Song info
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(song.name)
                        .font(.subheadline)
                        .fontWeight(isPlaying ? .semibold : .regular)
                        .foregroundColor(isPlaying ? .accentColor : .primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    if song.explicit {
                        ExplicitComponent()
                    }
                }
                
                Text(song.artistNames)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                // Price
                HStack {
                    Text(price)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.accentColor.opacity(0.5), lineWidth: 1)
                        )
                    
                    Spacer()
                }
                .padding(.top, 2)
            }
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        SongGridItem(
            song: Song(
                id: "1",
                name: "Midnight Dreams",
                artists: [Artist(id: "1", name: "Nsqk")],
                album: Album(artistName: "Nsqk", albumName: "ATP", imageName: "atp", isExplicit: true),
                durationMs: 234000,
                explicit: true
            ),
            price: "$0.99",
            isPlaying: false
        )
        .frame(width: 160)
        
        SongGridItem(
            song: Song(
                id: "2",
                name: "City Lights",
                artists: [Artist(id: "1", name: "Nsqk")],
                album: Album(artistName: "Nsqk", albumName: "ATP", imageName: "atp", isExplicit: true),
                durationMs: 198000,
                explicit: false
            ),
            price: "$1.29",
            isPlaying: true
        )
        .frame(width: 160)
    }
    .padding()
}

