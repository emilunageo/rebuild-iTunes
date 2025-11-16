//
//  Artist.swift
//  main
//
//  Created by Emiliano Luna George on 16/11/25.
//

import Foundation

/// Artist model compatible with Spotify/Apple Music API structure
struct Artist: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let images: [ArtistImage]?
    let genres: [String]?
    
    init(id: String, name: String, images: [ArtistImage]? = nil, genres: [String]? = nil) {
        self.id = id
        self.name = name
        self.images = images
        self.genres = genres
    }
}

struct ArtistImage: Codable, Hashable {
    let url: String
    let height: Int?
    let width: Int?
}

