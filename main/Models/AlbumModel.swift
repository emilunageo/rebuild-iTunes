//
//  AlbumModel.swift
//  main
//
//  Created by Emiliano Luna George on 12/11/25.
//

import Foundation

/// Album model compatible with Spotify/Apple Music API structure
struct Album: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let artists: [Artist]
    let images: [AlbumImage]
    let releaseDate: String?
    let totalTracks: Int?
    let albumType: String? // "album", "single", "compilation"

    // Legacy support for existing code
    var artistName: String {
        artists.first?.name ?? "Unknown Artist"
    }

    var albumName: String {
        name
    }

    // For local image support (will be replaced by URL loading)
    var imageName: String {
        // Extract image name from first image URL if it's a local asset
        images.first?.url ?? "placeholder"
    }

    var isExplicit: Bool {
        // This would come from track data in real API
        false
    }

    init(
        id: String,
        name: String,
        artists: [Artist],
        images: [AlbumImage],
        releaseDate: String? = nil,
        totalTracks: Int? = nil,
        albumType: String? = "album"
    ) {
        self.id = id
        self.name = name
        self.artists = artists
        self.images = images
        self.releaseDate = releaseDate
        self.totalTracks = totalTracks
        self.albumType = albumType
    }

    // Convenience initializer for backward compatibility
    init(artistName: String, albumName: String, imageName: String, isExplicit: Bool) {
        self.id = UUID().uuidString
        self.name = albumName
        self.artists = [Artist(id: UUID().uuidString, name: artistName)]
        self.images = [AlbumImage(url: imageName, height: 640, width: 640)]
        self.releaseDate = nil
        self.totalTracks = nil
        self.albumType = "album"
    }
}

struct AlbumImage: Codable, Hashable {
    let url: String
    let height: Int?
    let width: Int?
}
