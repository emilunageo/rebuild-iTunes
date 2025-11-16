//
//  CarouselView.swift
//  main
//
//  Created by Emiliano Luna George on 12/11/25.
//

import SwiftUI

struct CarouselView: View {
    let title: String
    let albums: [Album]
    let mockAlbums = [
        Album(artistName: "Nsqk", albumName: "ATP", imageName: "atp", isExplicit: true),
        Album(artistName: "Daniel Caesar", albumName: "Superpowers", imageName: "superpowers", isExplicit: false),
        Album(artistName: "Trueno", albumName: "Bien o Mal", imageName: "trueno", isExplicit: true)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(albums) { album in
                        CardComponent(album: album)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    CarouselView(title: "Albums", albums: [Album(artistName: "Nsqk", albumName: "ATP", imageName: "atp", isExplicit: true), Album(artistName: "Nsqk", albumName: "ATP", imageName: "atp", isExplicit: true), Album(artistName: "Nsqk", albumName: "ATP", imageName: "atp", isExplicit: true), Album(artistName: "Nsqk", albumName: "ATP", imageName: "atp", isExplicit: true)])
}
