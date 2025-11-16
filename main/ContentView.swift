//
//  ContentView.swift
//  main
//
//  Created by Emiliano Luna George on 07/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var playerViewModel = PlayerViewModel.shared

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Music", systemImage: "music.note")
                    }

                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
            }
            .environmentObject(playerViewModel)

            // Global Player Mini-Bar
            if playerViewModel.currentSong != nil {
                PlayerMiniBar()
                    .environmentObject(playerViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
