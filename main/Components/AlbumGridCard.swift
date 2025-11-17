//
//  AlbumGridCard.swift
//  main
//
//  Created by iTunes Store MVP
//  Grid-optimized version of AlbumCard for LazyVGrid layouts
//

import SwiftUI

struct AlbumGridCard: View {
    let album: Album
    let size: CGFloat
    
    init(album: Album, size: CGFloat = 160) {
        self.album = album
        self.size = size
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Album artwork
            if let firstImage = album.images.first {
                Image(firstImage.url)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipped()
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: size, height: size)
                    .cornerRadius(8)
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.6))
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            
            // Album info
            VStack(alignment: .leading, spacing: 4) {
                Text(album.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(album.artistName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                // Show explicit badge if any track is explicit
                // For now, we'll skip this since we don't have track info in album model
            }
            .frame(width: size, alignment: .leading)
        }
        .frame(width: size)
    }
}

#Preview {
    AlbumGridCard(
        album: Album(
            id: "1",
            name: "ATP",
            artists: [Artist(id: "1", name: "Nsqk", images: nil)],
            images: [AlbumImage(url: "atp", height: 640, width: 640)],
            releaseDate: "2024-03-15",
            totalTracks: 12,
            albumType: "album"
        )
    )
    .padding()
}

