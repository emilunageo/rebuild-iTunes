//
//  AlbumCard.swift
//  main
//
//  Created by Emiliano Luna George on 16/11/25.
//

import SwiftUI

/// Modern album card component following HIG
struct AlbumCard: View {
    let album: Album
    let size: CGFloat
    
    init(album: Album, size: CGFloat = 150) {
        self.album = album
        self.size = size
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Album artwork
            if let firstImage = album.images.first, let imageURL = URL(string: firstImage.url) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: size, height: size)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                ProgressView()
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size, height: size)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: size, height: size)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                Image(systemName: "music.note")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.6))
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.6))
                    )
            }
            
            // Album info
            VStack(alignment: .leading, spacing: 4) {
                Text(album.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Text(album.artistName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    if album.isExplicit {
                        ExplicitComponent()
                    }
                }
            }
        }
        .frame(width: size)
    }
}

#Preview {
    AlbumCard(
        album: Album(
            artistName: "Nsqk",
            albumName: "ATP",
            imageName: "atp",
            isExplicit: true
        )
    )
}

