//
//  Song.swift
//  main
//
//  Created by Emiliano Luna George on 16/11/25.
//

import Foundation

/// Song/Track model compatible with Spotify/Apple Music API structure
struct Song: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let artists: [Artist]
    let album: Album
    let durationMs: Int
    let explicit: Bool
    let previewUrl: String?
    let trackNumber: Int?
    let popularity: Int?
    
    init(
        id: String,
        name: String,
        artists: [Artist],
        album: Album,
        durationMs: Int,
        explicit: Bool = false,
        previewUrl: String? = nil,
        trackNumber: Int? = nil,
        popularity: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.artists = artists
        self.album = album
        self.durationMs = durationMs
        self.explicit = explicit
        self.previewUrl = previewUrl
        self.trackNumber = trackNumber
        self.popularity = popularity
    }
    
    // Computed properties for convenience
    var artistNames: String {
        artists.map { $0.name }.joined(separator: ", ")
    }
    
    var durationFormatted: String {
        let totalSeconds = durationMs / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var primaryArtist: Artist {
        artists.first ?? Artist(id: "unknown", name: "Unknown Artist")
    }
}

