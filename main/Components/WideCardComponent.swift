//
//  WideCardComponent.swift
//  main
//
//  Created by Emiliano Luna George on 13/11/25.
//

import SwiftUI

struct WideCardComponent: View {
    
    let album: Album
    
    var body: some View {
        VStack(alignment: .leading) {
            if let firstImage = album.images.first, let imageURL = URL(string: firstImage.url) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 300, height: 150)
                            .cornerRadius(10)
                            .overlay(
                                ProgressView()
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 300, height: 150)
                            .cornerRadius(10)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 300, height: 150)
                            .cornerRadius(10)
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
                    .frame(width: 300, height: 150)
                    .cornerRadius(10)
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.6))
                    )
            }

            HStack(alignment: .center) {
                Text(album.artistName)
                    .font(.headline)

                if album.isExplicit {
                    ExplicitComponent()
                }
            }
            Text(album.albumName)
                .font(.caption)
                .foregroundStyle(.gray)

        }
        .frame(width: 150)
    }
}

#Preview {
    WideCardComponent(album: Album(artistName: "Nsqk", albumName: "ATP", imageName: "atp", isExplicit: true))
}
