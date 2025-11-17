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

    private lazy var mockMusicVideos: [MusicVideo] = [
        MusicVideo(id: "mv1", title: "Midnight Dreams", artist: mockArtists[0],
                   previewImageURL: "atp", durationMs: 234000, explicit: true,
                   genre: "Electronic", releaseDate: "2024-03-15", viewCount: 2_450_000),
        MusicVideo(id: "mv2", title: "Superpowers", artist: mockArtists[1],
                   previewImageURL: "superpowers", durationMs: 187000, explicit: false,
                   genre: "R&B", releaseDate: "2023-11-10", viewCount: 5_200_000),
        MusicVideo(id: "mv3", title: "Bien o Mal", artist: mockArtists[2],
                   previewImageURL: "bienomal", durationMs: 245000, explicit: true,
                   genre: "Hip-Hop", releaseDate: "2024-01-20", viewCount: 8_100_000),
        MusicVideo(id: "mv4", title: "Anti-Hero", artist: mockArtists[3],
                   previewImageURL: "placeholder", durationMs: 200000, explicit: false,
                   genre: "Pop", releaseDate: "2022-10-21", viewCount: 15_300_000),
        MusicVideo(id: "mv5", title: "Blinding Lights", artist: mockArtists[4],
                   previewImageURL: "placeholder", durationMs: 200000, explicit: false,
                   genre: "Synthwave", releaseDate: "2020-03-20", viewCount: 25_700_000),
        MusicVideo(id: "mv6", title: "City Lights", artist: mockArtists[0],
                   previewImageURL: "atp", durationMs: 198000, explicit: true,
                   genre: "Electronic", releaseDate: "2024-03-15", viewCount: 1_800_000),
        MusicVideo(id: "mv7", title: "Tití Me Preguntó", artist: mockArtists[5],
                   previewImageURL: "placeholder", durationMs: 256000, explicit: false,
                   genre: "Reggaeton", releaseDate: "2022-05-06", viewCount: 12_400_000),
        MusicVideo(id: "mv8", title: "Always", artist: mockArtists[1],
                   previewImageURL: "superpowers", durationMs: 203000, explicit: false,
                   genre: "R&B", releaseDate: "2023-11-10", viewCount: 3_600_000),
        MusicVideo(id: "mv9", title: "Neon Waves", artist: mockArtists[0],
                   previewImageURL: "atp", durationMs: 256000, explicit: false,
                   genre: "Electronic", releaseDate: "2024-03-15", viewCount: 2_100_000),
        MusicVideo(id: "mv10", title: "Mamichula", artist: mockArtists[2],
                   previewImageURL: "bienomal", durationMs: 189000, explicit: true,
                   genre: "Hip-Hop", releaseDate: "2024-01-20", viewCount: 6_800_000)
    ]

    private lazy var mockRingtones: [Ringtone] = [
        // Classic Ringtones
        Ringtone(id: "rt1", title: "Classic Bell", artist: nil, category: .classic,
                 price: 1.29, imageURL: "waveform", durationMs: 30000),
        Ringtone(id: "rt2", title: "Piano Melody", artist: "Mozart", category: .classic,
                 price: 1.29, imageURL: "waveform", durationMs: 25000),
        Ringtone(id: "rt3", title: "Orchestral Rise", artist: nil, category: .classic,
                 price: 0.99, imageURL: "waveform", durationMs: 20000),
        Ringtone(id: "rt4", title: "Vintage Phone", artist: nil, category: .classic,
                 price: 0.99, imageURL: "waveform", durationMs: 15000),

        // Modern Ringtones
        Ringtone(id: "rt5", title: "Electronic Pulse", artist: "Nsqk", category: .modern,
                 price: 1.29, imageURL: "waveform", durationMs: 30000),
        Ringtone(id: "rt6", title: "Synth Wave", artist: "The Weeknd", category: .modern,
                 price: 1.29, imageURL: "waveform", durationMs: 28000),
        Ringtone(id: "rt7", title: "Bass Drop", artist: nil, category: .modern,
                 price: 0.99, imageURL: "waveform", durationMs: 22000),
        Ringtone(id: "rt8", title: "Future Beats", artist: "Drake", category: .modern,
                 price: 1.29, imageURL: "waveform", durationMs: 30000),
        Ringtone(id: "rt9", title: "Neon Dreams", artist: nil, category: .modern,
                 price: 0.99, imageURL: "waveform", durationMs: 25000),

        // Alert Tones
        Ringtone(id: "rt10", title: "Gentle Chime", artist: nil, category: .alert,
                 price: 0.99, imageURL: "waveform", durationMs: 5000),
        Ringtone(id: "rt11", title: "Urgent Alert", artist: nil, category: .alert,
                 price: 0.99, imageURL: "waveform", durationMs: 8000),
        Ringtone(id: "rt12", title: "Soft Bell", artist: nil, category: .alert,
                 price: 0.99, imageURL: "waveform", durationMs: 6000),
        Ringtone(id: "rt13", title: "Quick Beep", artist: nil, category: .alert,
                 price: 0.99, imageURL: "waveform", durationMs: 4000),

        // Notification Tones
        Ringtone(id: "rt14", title: "Message Pop", artist: nil, category: .notification,
                 price: 0.99, imageURL: "waveform", durationMs: 3000),
        Ringtone(id: "rt15", title: "Bubble Sound", artist: nil, category: .notification,
                 price: 0.99, imageURL: "waveform", durationMs: 2000),
        Ringtone(id: "rt16", title: "Ding", artist: nil, category: .notification,
                 price: 0.99, imageURL: "waveform", durationMs: 2500),
        Ringtone(id: "rt17", title: "Swoosh", artist: nil, category: .notification,
                 price: 0.99, imageURL: "waveform", durationMs: 3500),
        Ringtone(id: "rt18", title: "Ping", artist: nil, category: .notification,
                 price: 0.99, imageURL: "waveform", durationMs: 2000),
        Ringtone(id: "rt19", title: "Chime Notification", artist: nil, category: .notification,
                 price: 0.99, imageURL: "waveform", durationMs: 4000),
        Ringtone(id: "rt20", title: "Soft Tap", artist: nil, category: .notification,
                 price: 0.99, imageURL: "waveform", durationMs: 1500)
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

    /// Fetch all music videos
    func fetchMusicVideos() async -> [MusicVideo] {
        await simulateNetworkDelay()
        return mockMusicVideos
    }

    /// Fetch music video details
    func fetchMusicVideoDetails(videoId: String) async -> MusicVideo? {
        await simulateNetworkDelay()
        return mockMusicVideos.first { $0.id == videoId }
    }

    /// Fetch related music videos (for detail view)
    func fetchRelatedMusicVideos(videoId: String) async -> [MusicVideo] {
        await simulateNetworkDelay()
        // Return random videos excluding the current one
        return mockMusicVideos.filter { $0.id != videoId }.shuffled().prefix(4).map { $0 }
    }

    /// Fetch all ringtones
    func fetchRingtones() async -> [Ringtone] {
        await simulateNetworkDelay()
        return mockRingtones
    }

    /// Fetch ringtones by category
    func fetchRingtones(category: RingtoneCategory) async -> [Ringtone] {
        await simulateNetworkDelay()
        return mockRingtones.filter { $0.category == category }
    }

    /// Fetch ringtone details
    func fetchRingtoneDetails(ringtoneId: String) async -> Ringtone? {
        await simulateNetworkDelay()
        return mockRingtones.first { $0.id == ringtoneId }
    }

    /// Fetch similar ringtones (for detail view)
    func fetchSimilarRingtones(ringtoneId: String) async -> [Ringtone] {
        await simulateNetworkDelay()
        guard let ringtone = mockRingtones.first(where: { $0.id == ringtoneId }) else {
            return []
        }
        // Return ringtones from the same category, excluding the current one
        return mockRingtones.filter { $0.category == ringtone.category && $0.id != ringtoneId }
            .shuffled().prefix(4).map { $0 }
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

