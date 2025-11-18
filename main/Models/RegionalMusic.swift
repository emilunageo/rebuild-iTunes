//
//  RegionalMusic.swift
//  main
//
//  Created by Music Discovery Map Feature
//

import Foundation
import MapKit

/// Represents music data for a specific region/country
struct RegionalMusic: Identifiable, Codable {
    let id: String // Country code
    let countryCode: String
    let countryName: String
    let topSong: Song
    let latitude: Double
    let longitude: Double
    let fetchedAt: Date
    
    init(countryCode: String, countryName: String, topSong: Song, latitude: Double, longitude: Double) {
        self.id = countryCode
        self.countryCode = countryCode
        self.countryName = countryName
        self.topSong = topSong
        self.latitude = latitude
        self.longitude = longitude
        self.fetchedAt = Date()
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Check if cached data is still valid (1 hour expiration)
    var isExpired: Bool {
        Date().timeIntervalSince(fetchedAt) > 3600 // 1 hour
    }
}

/// Map annotation for displaying regional music on the map
class SongAnnotation: NSObject, MKAnnotation, Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let song: Song
    let countryCode: String
    let countryName: String
    
    init(regionalMusic: RegionalMusic) {
        self.id = regionalMusic.id
        self.coordinate = regionalMusic.coordinate
        self.title = regionalMusic.topSong.name
        self.subtitle = regionalMusic.topSong.artistNames
        self.song = regionalMusic.topSong
        self.countryCode = regionalMusic.countryCode
        self.countryName = regionalMusic.countryName
        super.init()
    }
    
    init(countryCode: String, countryName: String, song: Song, coordinate: CLLocationCoordinate2D) {
        self.id = countryCode
        self.coordinate = coordinate
        self.title = song.name
        self.subtitle = song.artistNames
        self.song = song
        self.countryCode = countryCode
        self.countryName = countryName
        super.init()
    }
}

/// Country coordinate data for major countries
struct CountryCoordinates {
    static let coordinates: [String: (latitude: Double, longitude: Double, name: String)] = [
        "US": (37.0902, -95.7129, "United States"),
        "GB": (55.3781, -3.4360, "United Kingdom"),
        "CA": (56.1304, -106.3468, "Canada"),
        "AU": (-25.2744, 133.7751, "Australia"),
        "DE": (51.1657, 10.4515, "Germany"),
        "FR": (46.2276, 2.2137, "France"),
        "IT": (41.8719, 12.5674, "Italy"),
        "ES": (40.4637, -3.7492, "Spain"),
        "MX": (23.6345, -102.5528, "Mexico"),
        "BR": (-14.2350, -51.9253, "Brazil"),
        "AR": (-38.4161, -63.6167, "Argentina"),
        "JP": (36.2048, 138.2529, "Japan"),
        "KR": (35.9078, 127.7669, "South Korea"),
        "CN": (35.8617, 104.1954, "China"),
        "IN": (20.5937, 78.9629, "India"),
        "RU": (61.5240, 105.3188, "Russia"),
        "SE": (60.1282, 18.6435, "Sweden"),
        "NO": (60.4720, 8.4689, "Norway"),
        "DK": (56.2639, 9.5018, "Denmark"),
        "FI": (61.9241, 25.7482, "Finland"),
        "NL": (52.1326, 5.2913, "Netherlands"),
        "BE": (50.5039, 4.4699, "Belgium"),
        "CH": (46.8182, 8.2275, "Switzerland"),
        "AT": (47.5162, 14.5501, "Austria"),
        "PL": (51.9194, 19.1451, "Poland"),
        "PT": (39.3999, -8.2245, "Portugal"),
        "GR": (39.0742, 21.8243, "Greece"),
        "TR": (38.9637, 35.2433, "Turkey"),
        "ZA": (-30.5595, 22.9375, "South Africa"),
        "NZ": (-40.9006, 174.8860, "New Zealand"),
        "SG": (1.3521, 103.8198, "Singapore"),
        "TH": (15.8700, 100.9925, "Thailand"),
        "ID": (-0.7893, 113.9213, "Indonesia"),
        "MY": (4.2105, 101.9758, "Malaysia"),
        "PH": (12.8797, 121.7740, "Philippines"),
        "VN": (14.0583, 108.2772, "Vietnam"),
        "AE": (23.4241, 53.8478, "United Arab Emirates"),
        "SA": (23.8859, 45.0792, "Saudi Arabia"),
        "IL": (31.0461, 34.8516, "Israel"),
        "EG": (26.8206, 30.8025, "Egypt"),
        "NG": (9.0820, 8.6753, "Nigeria"),
        "KE": (-0.0236, 37.9062, "Kenya"),
        "CL": (-35.6751, -71.5430, "Chile"),
        "CO": (4.5709, -74.2973, "Colombia"),
        "PE": (-9.1900, -75.0152, "Peru"),
        "VE": (6.4238, -66.5897, "Venezuela"),
        "IE": (53.4129, -8.2439, "Ireland"),
        "CZ": (49.8175, 15.4730, "Czech Republic"),
        "HU": (47.1625, 19.5033, "Hungary"),
        "RO": (45.9432, 24.9668, "Romania"),
        "UA": (48.3794, 31.1656, "Ukraine")
    ]
    
    static func getCoordinate(for countryCode: String) -> CLLocationCoordinate2D? {
        guard let data = coordinates[countryCode.uppercased()] else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
    }
    
    static func getCountryName(for countryCode: String) -> String? {
        return coordinates[countryCode.uppercased()]?.name
    }
}

