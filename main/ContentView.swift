//
//  ContentView.swift
//  main
//
//  Created by Emiliano Luna George on 07/11/25.
//

import SwiftUI

struct ContentView: View {
    let mockAlbums = [
        Album(artistName: "Nsqk", albumName: "ATP", imageName: "atp", isExplicit: true),
        Album(artistName: "Daniel Caesar", albumName: "superpowers", imageName: "superpowers", isExplicit: false),
        Album(artistName: "Trueno", albumName: "bienomal", imageName: "trueno", isExplicit: true)
    ]
    
    var body: some View {
        CarouselView(title: "Recently Played", albums: mockAlbums)
    }
}

#Preview {
    ContentView()
}
