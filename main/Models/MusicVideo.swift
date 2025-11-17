//
//  MusicVideo.swift
//  main
//
//  Created by iTunes Store MVP
//

import Foundation

struct MusicVideo: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let artist: Artist
    let previewImageURL: String?  // Mock URL or asset name
    let durationMs: Int
    let explicit: Bool
    let genre: String?
    let releaseDate: String?
    let viewCount: Int?  // Mock view count
    
    // Computed property for formatted duration
    var durationFormatted: String {
        let totalSeconds = durationMs / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // Computed property for formatted view count
    var viewCountFormatted: String {
        guard let count = viewCount else { return "0 views" }
        
        if count >= 1_000_000 {
            let millions = Double(count) / 1_000_000.0
            return String(format: "%.1fM views", millions)
        } else if count >= 1_000 {
            let thousands = Double(count) / 1_000.0
            return String(format: "%.1fK views", thousands)
        } else {
            return "\(count) views"
        }
    }
    
    // Computed property for artist name
    var artistName: String {
        artist.name
    }
    
    // Computed property for formatted release date
    var releaseDateFormatted: String? {
        guard let releaseDate = releaseDate else { return nil }
        
        // Parse ISO date string (e.g., "2024-01-15")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: releaseDate) {
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
        
        return releaseDate
    }
}

// MARK: - Supporting Types

struct MusicVideoImage: Codable, Hashable {
    let url: String
    let width: Int?
    let height: Int?
}

