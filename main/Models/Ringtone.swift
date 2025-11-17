//
//  Ringtone.swift
//  main
//
//  Created by iTunes Store MVP
//

import Foundation

enum RingtoneCategory: String, Codable, CaseIterable {
    case classic = "Classic"
    case modern = "Modern"
    case alert = "Alert Tones"
    case notification = "Notifications"
    
    var displayName: String {
        self.rawValue
    }
}

struct Ringtone: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let artist: String?
    let category: RingtoneCategory
    let price: Double  // Mock price (e.g., 1.29)
    let imageURL: String?  // Mock image or asset name
    let durationMs: Int
    
    // Computed property for formatted price
    var priceFormatted: String {
        return String(format: "$%.2f", price)
    }
    
    // Computed property for formatted duration
    var durationFormatted: String {
        let totalSeconds = durationMs / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        if minutes > 0 {
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            return String(format: "0:%02d", seconds)
        }
    }
    
    // Computed property for display artist
    var displayArtist: String {
        artist ?? "Unknown Artist"
    }
    
    // Computed property for category icon
    var categoryIcon: String {
        switch category {
        case .classic:
            return "music.note.list"
        case .modern:
            return "waveform"
        case .alert:
            return "bell.fill"
        case .notification:
            return "app.badge.fill"
        }
    }
}

