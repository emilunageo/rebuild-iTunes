//
//  SongRow.swift
//  main
//
//  Created by Emiliano Luna George on 16/11/25.
//

import SwiftUI

/// Song row component for lists
struct SongRow: View {
    let song: Song
    let showAlbumArt: Bool
    let isPlaying: Bool
    
    init(song: Song, showAlbumArt: Bool = true, isPlaying: Bool = false) {
        self.song = song
        self.showAlbumArt = showAlbumArt
        self.isPlaying = isPlaying
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Album artwork (optional)
            if showAlbumArt {
                Image(song.album.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            
            // Song info
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(song.name)
                        .font(.body)
                        .fontWeight(isPlaying ? .semibold : .regular)
                        .foregroundColor(isPlaying ? .accentColor : .primary)
                        .lineLimit(1)
                    
                    if song.explicit {
                        ExplicitComponent()
                    }
                }
                
                Text(song.artistNames)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Duration
            Text(song.durationFormatted)
                .font(.caption)
                .foregroundColor(.secondary)
                .monospacedDigit()
            
            // Playing indicator
            if isPlaying {
                Image(systemName: "waveform")
                    .foregroundColor(.accentColor)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    VStack {
        SongRow(
            song: Song(
                id: "1",
                name: "Midnight Dreams",
                artists: [Artist(id: "1", name: "Nsqk")],
                album: Album(artistName: "Nsqk", albumName: "ATP", imageName: "atp", isExplicit: true),
                durationMs: 234000,
                explicit: true
            ),
            isPlaying: false
        )
        
        SongRow(
            song: Song(
                id: "2",
                name: "City Lights",
                artists: [Artist(id: "1", name: "Nsqk")],
                album: Album(artistName: "Nsqk", albumName: "ATP", imageName: "atp", isExplicit: true),
                durationMs: 198000,
                explicit: false
            ),
            isPlaying: true
        )
    }
    .padding()
}

