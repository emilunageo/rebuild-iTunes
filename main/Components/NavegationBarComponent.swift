//
//  NavegationBarComponent.swift
//  main
//
//  Created by Emiliano Luna George on 14/11/25.
//

import SwiftUI

struct NavegationBarComponent: View {
    var body: some View {
        TabView {
            Tab("Music", systemImage: "music.note.house.fill"){
            }
            Tab("Videos", systemImage: "video.fill"){
            }
            Tab("Ringtones", systemImage:"phone.down.waves.left.and.right"){
            }
        }
    }
}

#Preview {
    NavegationBarComponent()
}

