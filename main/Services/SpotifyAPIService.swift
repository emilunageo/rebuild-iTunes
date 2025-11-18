//
//  SpotifyAPIService.swift
//  main
//
//  Created by iTunes Store MVP
//

import Foundation

/// Service for fetching data from Spotify Web API
class SpotifyAPIService {
    static let shared = SpotifyAPIService()
    
    private let authService = SpotifyAuthService.shared
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Generic Request Method
    
    private func makeRequest<T: Decodable>(
        endpoint: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> T {
        // Get access token
        let token = try await authService.getAccessToken()
        
        // Build URL
        var components = URLComponents(string: SpotifyConfig.baseURL + endpoint)!
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw SpotifyAPIError.invalidURL
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Make request
        let (data, response) = try await session.data(for: request)
        
        // Check response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SpotifyAPIError.invalidResponse
        }
        
        // Handle different status codes
        switch httpResponse.statusCode {
        case 200...299:
            // Success - decode response
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Decoding error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON: \(jsonString)")
                }
                throw SpotifyAPIError.decodingFailed(error)
            }
            
        case 401:
            // Unauthorized - clear auth and retry once
            await authService.clearAuthentication()
            throw SpotifyAPIError.unauthorized
            
        case 429:
            // Rate limited
            throw SpotifyAPIError.rateLimited
            
        case 400...499:
            throw SpotifyAPIError.clientError(statusCode: httpResponse.statusCode)
            
        case 500...599:
            throw SpotifyAPIError.serverError(statusCode: httpResponse.statusCode)
            
        default:
            throw SpotifyAPIError.unknownError(statusCode: httpResponse.statusCode)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Convert Spotify artist response to app Artist model
    private func convertToArtist(_ spotifyArtist: SpotifyArtistResponse) -> Artist {
        let images = spotifyArtist.images?.map { img in
            ArtistImage(url: img.url, height: img.height, width: img.width)
        }

        return Artist(
            id: spotifyArtist.id,
            name: spotifyArtist.name,
            images: images,
            genres: spotifyArtist.genres
        )
    }

    /// Convert Spotify simple artist to app Artist model
    private func convertSimpleArtistToArtist(_ spotifyArtist: SpotifySimpleArtist) -> Artist {
        return Artist(
            id: spotifyArtist.id,
            name: spotifyArtist.name,
            images: nil,
            genres: nil
        )
    }

    /// Convert Spotify album response to app Album model
    private func convertToAlbum(_ spotifyAlbum: SpotifyAlbumResponse) -> Album {
        let artists = spotifyAlbum.artists.map { convertSimpleArtistToArtist($0) }
        let images = spotifyAlbum.images.map { img in
            AlbumImage(url: img.url, height: img.height, width: img.width)
        }

        return Album(
            id: spotifyAlbum.id,
            name: spotifyAlbum.name,
            artists: artists,
            images: images,
            releaseDate: spotifyAlbum.releaseDate,
            totalTracks: spotifyAlbum.totalTracks,
            albumType: spotifyAlbum.albumType
        )
    }

    /// Convert Spotify track response to app Song model
    private func convertToSong(_ spotifyTrack: SpotifyTrackResponse) -> Song {
        let artists = spotifyTrack.artists.map { convertSimpleArtistToArtist($0) }

        // Convert album if available
        let album: Album
        if let spotifyAlbum = spotifyTrack.album {
            let albumArtists = spotifyAlbum.artists?.map { convertSimpleArtistToArtist($0) } ?? artists
            let albumImages = spotifyAlbum.images.map { img in
                AlbumImage(url: img.url, height: img.height, width: img.width)
            }

            album = Album(
                id: spotifyAlbum.id,
                name: spotifyAlbum.name,
                artists: albumArtists,
                images: albumImages,
                releaseDate: spotifyAlbum.releaseDate,
                totalTracks: nil,
                albumType: nil
            )
        } else {
            // Fallback album if not provided
            album = Album(
                id: "unknown",
                name: "Unknown Album",
                artists: artists,
                images: [],
                releaseDate: nil,
                totalTracks: nil,
                albumType: nil
            )
        }

        // Debug logging for preview URLs
        if spotifyTrack.previewUrl == nil {
            print("⚠️ API: Track '\(spotifyTrack.name)' has NO preview URL")
        } else {
            print("✅ API: Track '\(spotifyTrack.name)' has preview URL: \(spotifyTrack.previewUrl!)")
        }

        return Song(
            id: spotifyTrack.id,
            name: spotifyTrack.name,
            artists: artists,
            album: album,
            durationMs: spotifyTrack.durationMs,
            explicit: spotifyTrack.explicit,
            previewUrl: spotifyTrack.previewUrl,
            trackNumber: spotifyTrack.trackNumber,
            popularity: spotifyTrack.popularity
        )
    }

    // MARK: - Public API Methods

    /// Fetch new album releases
    func fetchNewReleases() async throws -> [Album] {
        let queryItems = [
            URLQueryItem(name: "limit", value: "\(SpotifyConfig.Params.defaultLimit)"),
            URLQueryItem(name: "country", value: SpotifyConfig.Params.defaultMarket)
        ]

        let response: SpotifyNewReleasesResponse = try await makeRequest(
            endpoint: SpotifyConfig.Endpoints.newReleases,
            queryItems: queryItems
        )

        return response.albums.items.map { convertToAlbum($0) }
    }

    /// Fetch trending albums (using new releases as proxy)
    func fetchTrendingAlbums() async throws -> [Album] {
        // Spotify doesn't have a direct "trending albums" endpoint
        // We'll use new releases with a different limit/offset
        let queryItems = [
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "offset", value: "5"),
            URLQueryItem(name: "country", value: SpotifyConfig.Params.defaultMarket)
        ]

        let response: SpotifyNewReleasesResponse = try await makeRequest(
            endpoint: SpotifyConfig.Endpoints.newReleases,
            queryItems: queryItems
        )

        return response.albums.items.map { convertToAlbum($0) }
    }

    /// Fetch trending songs (using featured playlists as proxy)
    func fetchTrendingSongs() async throws -> [Song] {
        // Spotify doesn't have a direct "trending" endpoint
        // We'll use featured playlists and get tracks from the first playlist
        let queryItems = [
            URLQueryItem(name: "limit", value: "1"),
            URLQueryItem(name: "country", value: SpotifyConfig.Params.defaultMarket)
        ]

        let response: SpotifyFeaturedPlaylistsResponse = try await makeRequest(
            endpoint: SpotifyConfig.Endpoints.featuredPlaylists,
            queryItems: queryItems
        )

        guard let firstPlaylist = response.playlists.items.first else {
            return []
        }

        // Fetch playlist tracks
        let playlistResponse: SpotifyPlaylistTracksResponse = try await makeRequest(
            endpoint: "/playlists/\(firstPlaylist.id)/tracks",
            queryItems: [URLQueryItem(name: "limit", value: "\(SpotifyConfig.Params.defaultLimit)")]
        )

        return playlistResponse.items.compactMap { item in
            guard let track = item.track else { return nil }
            return convertToSong(track)
        }
    }

    /// Fetch top songs (using search for popular tracks)
    func fetchTopSongs() async throws -> [Song] {
        // Search for popular tracks in a specific genre
        let queryItems = [
            URLQueryItem(name: "q", value: "year:2024"),
            URLQueryItem(name: "type", value: "track"),
            URLQueryItem(name: "limit", value: "\(SpotifyConfig.Params.defaultLimit)"),
            URLQueryItem(name: "market", value: SpotifyConfig.Params.defaultMarket)
        ]

        let response: SpotifySearchResponse = try await makeRequest(
            endpoint: SpotifyConfig.Endpoints.search,
            queryItems: queryItems
        )

        return response.tracks?.items.map { convertToSong($0) } ?? []
    }

    /// Fetch album details with tracks
    func fetchAlbumDetails(albumId: String) async throws -> Album {
        let response: SpotifyAlbumResponse = try await makeRequest(
            endpoint: "\(SpotifyConfig.Endpoints.albums)/\(albumId)"
        )

        return convertToAlbum(response)
    }

    /// Fetch artist details
    func fetchArtistDetails(artistId: String) async throws -> Artist {
        let response: SpotifyArtistResponse = try await makeRequest(
            endpoint: "\(SpotifyConfig.Endpoints.artists)/\(artistId)"
        )

        return convertToArtist(response)
    }

    /// Search for tracks, albums, and artists
    func search(query: String) async throws -> SearchResults {
        let queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "type", value: "track,album,artist"),
            URLQueryItem(name: "limit", value: "\(SpotifyConfig.Params.defaultLimit)"),
            URLQueryItem(name: "market", value: SpotifyConfig.Params.defaultMarket)
        ]

        let response: SpotifySearchResponse = try await makeRequest(
            endpoint: SpotifyConfig.Endpoints.search,
            queryItems: queryItems
        )

        return SearchResults(
            songs: response.tracks?.items.map { convertToSong($0) } ?? [],
            albums: response.albums?.items.map { convertToAlbum($0) } ?? [],
            artists: response.artists?.items.map { convertToArtist($0) } ?? []
        )
    }

    /// Fetch tracks for an album
    func fetchAlbumTracks(albumId: String) async throws -> [Song] {
        let response: SpotifyAlbumResponse = try await makeRequest(
            endpoint: "\(SpotifyConfig.Endpoints.albums)/\(albumId)"
        )

        return response.tracks?.items.map { convertToSong($0) } ?? []
    }

    // MARK: - Regional Music Discovery Methods

    /// Search for "Top 50" playlist for a specific country
    /// This is more reliable than featured playlists which may not exist for all countries
    func searchTopPlaylistForCountry(countryCode: String, countryName: String) async throws -> [Song] {
        print("🔍 Searching for top playlist for \(countryName) (\(countryCode))")

        // Try multiple search strategies to find the best playlist
        let searchQueries = [
            "Top 50 \(countryName)",
            "Top Songs \(countryName)",
            "Top 100 \(countryName)",
            "Viral 50 \(countryName)",
            "Top 50 \(countryCode.uppercased())"  // Try with country code too
        ]

        for query in searchQueries {
            let queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "type", value: "playlist"),
                URLQueryItem(name: "market", value: countryCode.uppercased()),
                URLQueryItem(name: "limit", value: "10")  // Increased from 5 to 10 for better results
            ]

            do {
                let response: SpotifySearchResponse = try await makeRequest(
                    endpoint: SpotifyConfig.Endpoints.search,
                    queryItems: queryItems
                )

                print("📋 Found \(response.playlists?.items.count ?? 0) playlists for query: \(query)")

                // Log all playlists found for debugging
                if let playlists = response.playlists?.items {
                    for (index, playlist) in playlists.enumerated() {
                        print("  [\(index)] \(playlist.name) by \(playlist.owner?.displayName ?? "unknown")")
                    }
                }

                // Find the first playlist that looks like an official chart
                // Prioritize Spotify-owned playlists
                if let playlist = response.playlists?.items.first(where: { playlist in
                    let name = playlist.name.lowercased()
                    let isSpotifyOwned = playlist.owner?.displayName?.lowercased().contains("spotify") == true ||
                                        playlist.owner?.id.lowercased() == "spotify"
                    let hasTopKeyword = name.contains("top 50") || name.contains("top 100") ||
                                       name.contains("viral 50") || name.contains("top songs")

                    // Prefer Spotify-owned playlists with top keywords
                    return isSpotifyOwned && hasTopKeyword
                }) ?? response.playlists?.items.first(where: { playlist in
                    // Fallback: any playlist with top keywords
                    let name = playlist.name.lowercased()
                    return name.contains("top 50") || name.contains("top 100") || name.contains("viral 50")
                }) {
                    print("✅ Selected playlist: \(playlist.name) by \(playlist.owner?.displayName ?? "unknown")")

                    // Fetch tracks from this playlist
                    let tracksResponse: SpotifyPlaylistTracksResponse = try await makeRequest(
                        endpoint: "/playlists/\(playlist.id)/tracks",
                        queryItems: [URLQueryItem(name: "limit", value: "10"), URLQueryItem(name: "market", value: countryCode.uppercased())]
                    )

                    let songs = tracksResponse.items.compactMap { item -> Song? in
                        guard let track = item.track else { return nil }
                        return convertToSong(track)
                    }

                    if !songs.isEmpty {
                        print("🎵 Found \(songs.count) songs from playlist for \(countryName)")
                        if let firstSong = songs.first {
                            print("   First song: \(firstSong.name) by \(firstSong.artistNames)")
                        }
                        return songs
                    }
                }
            } catch {
                print("⚠️ Error searching with query '\(query)': \(error)")
                // Continue to next search query
                continue
            }
        }

        print("⚠️ No playlists found, trying fallback method for \(countryName)")
        // Fallback: try new releases for this country
        return try await fetchNewReleasesTopSongs(countryCode: countryCode)
    }

    /// Fallback method: Get top songs from new releases
    private func fetchNewReleasesTopSongs(countryCode: String) async throws -> [Song] {
        print("🔄 Using fallback: fetching new releases for \(countryCode)")

        let queryItems = [
            URLQueryItem(name: "country", value: countryCode.uppercased()),
            URLQueryItem(name: "limit", value: "20")  // Increased limit for better variety
        ]

        let response: SpotifyNewReleasesResponse = try await makeRequest(
            endpoint: SpotifyConfig.Endpoints.newReleases,
            queryItems: queryItems
        )

        print("📀 Found \(response.albums.items.count) new releases for \(countryCode)")

        // Get the first track from each album
        var songs: [Song] = []
        for album in response.albums.items.prefix(10) {  // Increased from 5 to 10
            do {
                let albumResponse: SpotifyAlbumResponse = try await makeRequest(
                    endpoint: "\(SpotifyConfig.Endpoints.albums)/\(album.id)",
                    queryItems: [URLQueryItem(name: "market", value: countryCode.uppercased())]
                )

                if let firstTrack = albumResponse.tracks?.items.first {
                    let song = convertToSong(firstTrack)
                    songs.append(song)
                    print("  ✓ Added: \(song.name) by \(song.artistNames)")
                }
            } catch {
                print("  ✗ Failed to fetch album \(album.id): \(error)")
                continue
            }
        }

        if songs.isEmpty {
            print("⚠️ No songs found from new releases for \(countryCode)")
        } else {
            print("✅ Returning \(songs.count) songs from new releases for \(countryCode)")
        }

        return songs
    }

    /// Fetch top song for a country (from Top 50 playlist or new releases)
    func fetchTopSongForCountry(countryCode: String) async throws -> Song? {
        // Get country name from CountryCoordinates
        let countryName: String
        if let countryData = CountryCoordinates.coordinates[countryCode.uppercased()] {
            countryName = countryData.name
        } else {
            // Fallback to using country code as name
            countryName = countryCode
        }

        let songs = try await searchTopPlaylistForCountry(countryCode: countryCode, countryName: countryName)
        return songs.first
    }

    /// Fetch regional data for multiple countries
    func fetchRegionalData(for countryCodes: [String]) async throws -> [String: Song] {
        var regionalData: [String: Song] = [:]

        // Fetch data for each country concurrently
        await withTaskGroup(of: (String, Song?).self) { group in
            for countryCode in countryCodes {
                group.addTask {
                    do {
                        let song = try await self.fetchTopSongForCountry(countryCode: countryCode)
                        return (countryCode, song)
                    } catch {
                        print("Failed to fetch data for \(countryCode): \(error)")
                        return (countryCode, nil)
                    }
                }
            }

            for await (countryCode, song) in group {
                if let song = song {
                    regionalData[countryCode] = song
                }
            }
        }

        return regionalData
    }
}

// MARK: - Supporting Types

// Additional response model for playlist tracks
private struct SpotifyPlaylistTracksResponse: Codable {
    let items: [SpotifyPlaylistTrackItem]
}

private struct SpotifyPlaylistTrackItem: Codable {
    let track: SpotifyTrackResponse?
}

// MARK: - Errors

enum SpotifyAPIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case rateLimited
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case unknownError(statusCode: Int)
    case decodingFailed(Error)
    case noPreviewAvailable
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid response from Spotify"
        case .unauthorized:
            return "Authentication failed. Please check your credentials."
        case .rateLimited:
            return "Too many requests. Please try again later."
        case .clientError(let code):
            return "Request error (code: \(code))"
        case .serverError(let code):
            return "Spotify server error (code: \(code))"
        case .unknownError(let code):
            return "Unknown error (code: \(code))"
        case .decodingFailed(let error):
            return "Failed to parse response: \(error.localizedDescription)"
        case .noPreviewAvailable:
            return "No preview available for this track"
        }
    }
}

