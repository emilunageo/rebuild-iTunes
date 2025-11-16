//
//  CardView.swift
//  main
//
//  Created by Emiliano Luna George on 12/11/25.
//

import SwiftUI

struct CardComponent: View {
    
    let album: Album
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(album.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .cornerRadius(10)
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
    CardComponent(album: Album(artistName: "Nsqk", albumName: "ATP", imageName: "atp", isExplicit: true))
}
