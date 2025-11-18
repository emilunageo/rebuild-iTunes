//
//  LocationManager.swift
//  main
//
//  Created by Music Discovery Map Feature
//

import Foundation
import CoreLocation
import Combine

/// Manages location services for the music discovery map
@MainActor
class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentCountryCode: String?
    @Published var currentCountryName: String?
    @Published var errorMessage: String?
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100 // Update every 100 meters
        authorizationStatus = locationManager.authorizationStatus
    }
    
    /// Request location permissions
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Start tracking user location
    func startTracking() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            errorMessage = "Location permission not granted"
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    /// Stop tracking user location
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    /// Get country code from coordinates
    func getCountryCode(for location: CLLocation) async throws -> String? {
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        
        guard let placemark = placemarks.first else {
            return nil
        }
        
        await MainActor.run {
            self.currentCountryCode = placemark.isoCountryCode
            self.currentCountryName = placemark.country
        }
        
        return placemark.isoCountryCode
    }
    
    /// Get country codes for multiple locations (for map region)
    func getCountryCodes(for locations: [CLLocation]) async -> Set<String> {
        var countryCodes = Set<String>()
        
        for location in locations {
            do {
                if let countryCode = try await getCountryCode(for: location) {
                    countryCodes.insert(countryCode)
                }
            } catch {
                print("Failed to geocode location: \(error.localizedDescription)")
            }
        }
        
        return countryCodes
    }
    
    /// Get country code from coordinate
    func getCountryCode(latitude: Double, longitude: Double) async throws -> String? {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        return try await getCountryCode(for: location)
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            authorizationStatus = manager.authorizationStatus
            
            // Auto-start tracking when authorized
            if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
                startTracking()
            }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            guard let location = locations.last else { return }
            
            userLocation = location
            
            // Reverse geocode to get country
            do {
                _ = try await getCountryCode(for: location)
            } catch {
                errorMessage = "Failed to determine country: \(error.localizedDescription)"
            }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            errorMessage = "Location error: \(error.localizedDescription)"
            print("❌ Location Manager Error: \(error)")
        }
    }
}

