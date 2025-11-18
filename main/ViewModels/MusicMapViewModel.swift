//
//  MusicMapViewModel.swift
//  main
//
//  Created by Music Discovery Map Feature
//

import Foundation
import MapKit
import Combine

@MainActor
class MusicMapViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var annotations: [SongAnnotation] = []
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129),
        span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
    )
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showFindInAreaButton = false
    @Published var selectedAnnotation: SongAnnotation?
    
    // MARK: - Services
    
    private let locationManager = LocationManager.shared
    private let apiService = SpotifyAPIService.shared
    private let cache = RegionalMusicCache.shared
    
    // MARK: - Private Properties
    
    private var lastFetchedRegion: MKCoordinateRegion?
    private let minimumDistanceForNewFetch: CLLocationDistance = 500_000 // 500 km
    
    // MARK: - Initialization

    init() {
        setupLocationTracking()
        // Clear cache on init to force fresh data (temporary fix for corrupted cache)
        // TODO: Remove this after testing
        #if DEBUG
        cache.forceClearCache()
        #endif
    }
    
    // MARK: - Setup

    private func setupLocationTracking() {
        // Request location permission
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestPermission()
        }
    }

    // MARK: - Public Methods

    /// Load initial data
    func loadInitialData() async {
        // Observe user location and center map on first load
        if let location = locationManager.userLocation, lastFetchedRegion == nil {
            region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
            )
            await fetchDataForCurrentLocation()
        } else {
            // If no location yet, wait for it
            await observeLocationOnce()
        }
    }

    /// Observe location once for initial setup
    private func observeLocationOnce() async {
        for await location in locationManager.$userLocation.values {
            if let location = location, lastFetchedRegion == nil {
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
                )
                await fetchDataForCurrentLocation()
                break // Only observe once
            }
        }
    }

    /// Handle map region changes
    func onRegionChanged(_ newRegion: MKCoordinateRegion) {
        // Use Task to avoid publishing changes during view updates
        Task { @MainActor in
            updateFindInAreaButtonVisibility(for: newRegion)
        }
    }
    
    /// Fetch data for the current map region
    func fetchDataForRegion() async {
        isLoading = true
        errorMessage = nil
        showFindInAreaButton = false
        
        do {
            // Get countries visible in the current region
            let countryCodes = getCountriesInRegion(region)

            // Filter out already cached countries
            let uncachedCountries = countryCodes.filter { !cache.isCached(countryCode: $0) }

            // Fetch data for uncached countries
            if !uncachedCountries.isEmpty {
                print("🌍 Fetching data for \(uncachedCountries.count) countries: \(uncachedCountries.joined(separator: ", "))")
                let regionalData = try await apiService.fetchRegionalData(for: uncachedCountries)

                print("✅ Received data for \(regionalData.count) countries")

                // Create RegionalMusic objects and cache them
                var newRegionalMusic: [RegionalMusic] = []
                for (countryCode, song) in regionalData {
                    if let coordinate = CountryCoordinates.getCoordinate(for: countryCode),
                       let countryName = CountryCoordinates.getCountryName(for: countryCode) {
                        let regionalMusic = RegionalMusic(
                            countryCode: countryCode,
                            countryName: countryName,
                            topSong: song,
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude
                        )
                        newRegionalMusic.append(regionalMusic)
                        print("  ✓ \(countryCode): \(song.name) by \(song.artistNames)")
                    }
                }

                // Cache the new data
                if !newRegionalMusic.isEmpty {
                    cache.setMultiple(newRegionalMusic)
                    print("💾 Cached \(newRegionalMusic.count) regional music entries")
                }

                // Log countries that didn't return data
                let countriesWithoutData = uncachedCountries.filter { !regionalData.keys.contains($0) }
                if !countriesWithoutData.isEmpty {
                    print("⚠️ No data available for: \(countriesWithoutData.joined(separator: ", "))")
                }
            }

            // Update annotations with all cached data for visible countries
            updateAnnotations(for: countryCodes)

            // Update last fetched region
            lastFetchedRegion = region

        } catch {
            errorMessage = "Failed to load regional music: \(error.localizedDescription)"
            print("❌ Error fetching regional data: \(error)")
        }

        isLoading = false
    }

    /// Fetch data for user's current location
    private func fetchDataForCurrentLocation() async {
        guard let countryCode = locationManager.currentCountryCode else {
            return
        }

        // Check cache first
        if cache.isCached(countryCode: countryCode) {
            updateAnnotations(for: [countryCode])
            return
        }

        isLoading = true

        do {
            if let song = try await apiService.fetchTopSongForCountry(countryCode: countryCode),
               let coordinate = CountryCoordinates.getCoordinate(for: countryCode),
               let countryName = CountryCoordinates.getCountryName(for: countryCode) {

                let regionalMusic = RegionalMusic(
                    countryCode: countryCode,
                    countryName: countryName,
                    topSong: song,
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )

                cache.set(regionalMusic: regionalMusic)
                updateAnnotations(for: [countryCode])
            }
        } catch {
            errorMessage = "Failed to load music for your location"
            print("❌ Error fetching current location data: \(error)")
        }

        isLoading = false
    }

    // MARK: - Private Helper Methods

    /// Update annotations for given country codes
    private func updateAnnotations(for countryCodes: [String]) {
        var newAnnotations: [SongAnnotation] = []

        for countryCode in countryCodes {
            if let regionalMusic = cache.get(countryCode: countryCode) {
                let annotation = SongAnnotation(regionalMusic: regionalMusic)
                newAnnotations.append(annotation)
            }
        }

        annotations = newAnnotations
    }

    /// Get country codes visible in the map region
    private func getCountriesInRegion(_ region: MKCoordinateRegion) -> [String] {
        var visibleCountries: [String] = []

        // Sample points across the visible region
        let center = region.center
        let latDelta = region.span.latitudeDelta
        let lonDelta = region.span.longitudeDelta

        // Check which countries from our database are visible
        for (countryCode, data) in CountryCoordinates.coordinates {
            let countryLat = data.latitude
            let countryLon = data.longitude

            // Check if country center is within visible region
            if abs(countryLat - center.latitude) <= latDelta / 2 &&
               abs(countryLon - center.longitude) <= lonDelta / 2 {
                visibleCountries.append(countryCode)
            }
        }

        return visibleCountries
    }

    /// Update visibility of "Find in this area" button
    private func updateFindInAreaButtonVisibility(for newRegion: MKCoordinateRegion) {
        guard let lastRegion = lastFetchedRegion else {
            showFindInAreaButton = true
            return
        }

        // Calculate distance between current and last fetched region
        let currentLocation = CLLocation(
            latitude: newRegion.center.latitude,
            longitude: newRegion.center.longitude
        )
        let lastLocation = CLLocation(
            latitude: lastRegion.center.latitude,
            longitude: lastRegion.center.longitude
        )

        let distance = currentLocation.distance(from: lastLocation)
        showFindInAreaButton = distance > minimumDistanceForNewFetch
    }

    /// Select an annotation
    func selectAnnotation(_ annotation: SongAnnotation) {
        selectedAnnotation = annotation
    }

    /// Deselect annotation
    func deselectAnnotation() {
        selectedAnnotation = nil
    }
}


