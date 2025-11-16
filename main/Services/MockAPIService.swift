//
//  MockAPIService.swift
//  main
//
//  Created by Emiliano Luna George on 16/11/25.
//

import Foundation

/// Mock API Service that simulates network calls with delays
/// Structure is ready to be replaced with real Spotify/Apple Music API
class MockAPIService {
    static let shared = MockAPIService()
    
    private init() {}
    
    // MARK: - Mock Data
    
    private lazy var mockArtists: [Artist] = [
        Artist(id: "1", name: "Nsqk", images: [ArtistImage(url: "atp", height: 640, width: 640)]),
        Artist(id: "2", name: "Daniel Caesar", images: [ArtistImage(url: "superpowers", height: 640, width: 640)]),
        Artist(id: "3", name: "Trueno", images: [ArtistImage(url: "bienomal", height: 640, width: 640)]),
        Artist(id: "4", name: "Taylor Swift", images: nil),
        Artist(id: "5", name: "The Weeknd", images: nil),
        Artist(id: "6", name: "Bad Bunny", images: nil),
        Artist(id: "7", name: "Drake", images: nil),
        Artist(id: "8", name: "Billie Eilish", images: nil),
        Artist(id: "9", name: "Ed Sheeran", images: nil),
        Artist(id: "10", name: "Ariana Grande", images: nil)
    ]
    
    private lazy var mockAlbums: [Album] = [
        Album(
            id: "album1",
            name: "ATP",
            artists: [mockArtists[0]],
            images: [AlbumImage(url: "atp", height: 640, width: 640)],
            releaseDate: "2024-03-15",
            totalTracks: 12,
            albumType: "album"
        ),
        Album(
            id: "album2",
            name: "Superpowers",
            artists: [mockArtists[1]],
            images: [AlbumImage(url: "superpowers", height: 640, width: 640)],
            releaseDate: "2023-11-10",
            totalTracks: 10,
            albumType: "album"
        ),
        Album(
            id: "album3",
            name: "Bien o Mal",
            artists: [mockArtists[2]],
            images: [AlbumImage(url: "bienomal", height: 640, width: 640)],
            releaseDate: "2024-01-20",
            totalTracks: 14,
            albumType: "album"
        ),
        Album(
            id: "album4",
            name: "Midnights",
            artists: [mockArtists[3]],
            images: [AlbumImage(url: "placeholder", height: 640, width: 640)],
            releaseDate: "2022-10-21",
            totalTracks: 13,
            albumType: "album"
        ),
        Album(
            id: "album5",
            name: "After Hours",
            artists: [mockArtists[4]],
            images: [AlbumImage(url: "placeholder", height: 640, width: 640)],
            releaseDate: "2020-03-20",
            totalTracks: 14,
            albumType: "album"
        ),
        Album(
            id: "album6",
            name: "Un Verano Sin Ti",
            artists: [mockArtists[5]],
            images: [AlbumImage(url: "placeholder", height: 640, width: 640)],
            releaseDate: "2022-05-06",
            totalTracks: 23,
            albumType: "album"
        )
    ]
    
    private lazy var mockSongs: [Song] = [
        // ATP Album
        Song(id: "song1", name: "Midnight Dreams", artists: [mockArtists[0]], album: mockAlbums[0], 
             durationMs: 234000, explicit: true, previewUrl: "preview", trackNumber: 1, popularity: 85),
        Song(id: "song2", name: "City Lights", artists: [mockArtists[0]], album: mockAlbums[0], 
             durationMs: 198000, explicit: true, previewUrl: "preview", trackNumber: 2, popularity: 78),
        Song(id: "song3", name: "Neon Waves", artists: [mockArtists[0]], album: mockAlbums[0], 
             durationMs: 256000, explicit: false, previewUrl: "preview", trackNumber: 3, popularity: 82),
        
        // Superpowers Album
        Song(id: "song4", name: "Superpowers", artists: [mockArtists[1]], album: mockAlbums[1], 
             durationMs: 187000, explicit: false, previewUrl: "preview", trackNumber: 1, popularity: 92),
        Song(id: "song5", name: "Always", artists: [mockArtists[1]], album: mockAlbums[1], 
             durationMs: 203000, explicit: false, previewUrl: "preview", trackNumber: 2, popularity: 88),
        Song(id: "song6", name: "Valentina", artists: [mockArtists[1]], album: mockAlbums[1], 
             durationMs: 221000, explicit: false, previewUrl: "preview", trackNumber: 3, popularity: 86),
        
        // Bien o Mal Album
        Song(id: "song7", name: "Bien o Mal", artists: [mockArtists[2]], album: mockAlbums[2], 
             durationMs: 245000, explicit: true, previewUrl: "preview", trackNumber: 1, popularity: 90),
        Song(id: "song8", name: "Mamichula", artists: [mockArtists[2]], album: mockAlbums[2], 
             durationMs: 189000, explicit: true, previewUrl: "preview", trackNumber: 2, popularity: 87),
        Song(id: "song9", name: "Dance Crip", artists: [mockArtists[2]], album: mockAlbums[2], 
             durationMs: 212000, explicit: true, previewUrl: "preview", trackNumber: 3, popularity: 84),
        
        // Other albums
        Song(id: "song10", name: "Anti-Hero", artists: [mockArtists[3]], album: mockAlbums[3], 
             durationMs: 200000, explicit: false, previewUrl: "preview", trackNumber: 1, popularity: 95),
        Song(id: "song11", name: "Blinding Lights", artists: [mockArtists[4]], album: mockAlbums[4], 
             durationMs: 200000, explicit: false, previewUrl: "preview", trackNumber: 1, popularity: 98),
        Song(id: "song12", name: "Tití Me Preguntó", artists: [mockArtists[5]], album: mockAlbums[5],
             durationMs: 256000, explicit: false, previewUrl: "preview", trackNumber: 1, popularity: 93)
    ]

    // MARK: - API Methods

    /// Simulates network delay
    private func simulateNetworkDelay() async {
        let delay = Double.random(in: 0.3...0.8)
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
    }

    /// Fetch new releases
    func fetchNewReleases() async -> [Album] {
        await simulateNetworkDelay()
        return Array(mockAlbums.prefix(3))
    }

    /// Fetch trending albums
    func fetchTrendingAlbums() async -> [Album] {
        await simulateNetworkDelay()
        return Array(mockAlbums.shuffled().prefix(4))
    }

    /// Fetch top songs
    func fetchTopSongs() async -> [Song] {
        await simulateNetworkDelay()
        return mockSongs.sorted { ($0.popularity ?? 0) > ($1.popularity ?? 0) }.prefix(6).map { $0 }
    }

    /// Fetch all songs for an album
    func fetchAlbumTracks(albumId: String) async -> [Song] {
        await simulateNetworkDelay()
        return mockSongs.filter { $0.album.id == albumId }
    }

    /// Fetch song details
    func fetchSongDetails(songId: String) async -> Song? {
        await simulateNetworkDelay()
        return mockSongs.first { $0.id == songId }
    }

    /// Fetch album details
    func fetchAlbumDetails(albumId: String) async -> Album? {
        await simulateNetworkDelay()
        return mockAlbums.first { $0.id == albumId }
    }

    /// Search for songs, albums, and artists
    func search(query: String) async -> SearchResults {
        await simulateNetworkDelay()

        let lowercasedQuery = query.lowercased()

        let songs = mockSongs.filter {
            $0.name.lowercased().contains(lowercasedQuery) ||
            $0.artistNames.lowercased().contains(lowercasedQuery)
        }

        let albums = mockAlbums.filter {
            $0.name.lowercased().contains(lowercasedQuery) ||
            $0.artistName.lowercased().contains(lowercasedQuery)
        }

        let artists = mockArtists.filter {
            $0.name.lowercased().contains(lowercasedQuery)
        }

        return SearchResults(songs: songs, albums: albums, artists: artists)
    }

    /// Get all available albums (for home feed)
    func fetchAllAlbums() async -> [Album] {
        await simulateNetworkDelay()
        return mockAlbums
    }
}

// MARK: - Search Results Model

struct SearchResults {
    let songs: [Song]
    let albums: [Album]
    let artists: [Artist]

    var isEmpty: Bool {
        songs.isEmpty && albums.isEmpty && artists.isEmpty
    }
}

