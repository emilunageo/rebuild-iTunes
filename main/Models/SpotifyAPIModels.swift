//
//  SpotifyAPIModels.swift
//  main
//
//  Created by iTunes Store MVP
//  Models for mapping Spotify Web API JSON responses
//

import Foundation

// MARK: - Common Models

struct SpotifyImage: Codable {
    let url: String
    let height: Int?
    let width: Int?
}

struct SpotifyExternalUrls: Codable {
    let spotify: String
}

// MARK: - Artist Response

struct SpotifyArtistResponse: Codable {
    let id: String
    let name: String
    let images: [SpotifyImage]?
    let genres: [String]?
    let popularity: Int?
    let followers: SpotifyFollowers?
    let externalUrls: SpotifyExternalUrls?
    
    enum CodingKeys: String, CodingKey {
        case id, name, images, genres, popularity, followers
        case externalUrls = "external_urls"
    }
}

struct SpotifyFollowers: Codable {
    let total: Int
}

// MARK: - Album Response

struct SpotifyAlbumResponse: Codable {
    let id: String
    let name: String
    let artists: [SpotifySimpleArtist]
    let images: [SpotifyImage]
    let releaseDate: String
    let totalTracks: Int
    let tracks: SpotifyTracksPage?
    let albumType: String?
    let externalUrls: SpotifyExternalUrls?
    
    enum CodingKeys: String, CodingKey {
        case id, name, artists, images, tracks
        case releaseDate = "release_date"
        case totalTracks = "total_tracks"
        case albumType = "album_type"
        case externalUrls = "external_urls"
    }
}

struct SpotifySimpleArtist: Codable {
    let id: String
    let name: String
    let externalUrls: SpotifyExternalUrls?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case externalUrls = "external_urls"
    }
}

// MARK: - Track Response

struct SpotifyTrackResponse: Codable {
    let id: String
    let name: String
    let artists: [SpotifySimpleArtist]
    let album: SpotifySimpleAlbum?
    let durationMs: Int
    let explicit: Bool
    let previewUrl: String?
    let trackNumber: Int?
    let popularity: Int?
    let externalUrls: SpotifyExternalUrls?
    
    enum CodingKeys: String, CodingKey {
        case id, name, artists, album, explicit, popularity
        case durationMs = "duration_ms"
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case externalUrls = "external_urls"
    }
}

struct SpotifySimpleAlbum: Codable {
    let id: String
    let name: String
    let images: [SpotifyImage]
    let releaseDate: String?
    let artists: [SpotifySimpleArtist]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, images, artists
        case releaseDate = "release_date"
    }
}

// MARK: - Paging Response

struct SpotifyTracksPage: Codable {
    let items: [SpotifyTrackResponse]
    let total: Int
    let limit: Int
    let offset: Int
}

struct SpotifyAlbumsPage: Codable {
    let items: [SpotifyAlbumResponse]
    let total: Int
    let limit: Int
    let offset: Int
}

// MARK: - Browse Responses

struct SpotifyNewReleasesResponse: Codable {
    let albums: SpotifyAlbumsPage
}

struct SpotifyFeaturedPlaylistsResponse: Codable {
    let playlists: SpotifyPlaylistsPage
}

struct SpotifyPlaylistsPage: Codable {
    let items: [SpotifyPlaylist]
}

struct SpotifyPlaylist: Codable {
    let id: String
    let name: String
    let images: [SpotifyImage]?
    let tracks: SpotifyPlaylistTracks?
    let owner: SpotifyPlaylistOwner?
}

struct SpotifyPlaylistOwner: Codable {
    let id: String
    let displayName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
    }
}

struct SpotifyPlaylistTracks: Codable {
    let total: Int
}

// MARK: - Search Response

struct SpotifySearchResponse: Codable {
    let tracks: SpotifyTracksPage?
    let albums: SpotifyAlbumsPage?
    let artists: SpotifyArtistsPage?
    let playlists: SpotifyPlaylistsPage?
}

struct SpotifyArtistsPage: Codable {
    let items: [SpotifyArtistResponse]
}

