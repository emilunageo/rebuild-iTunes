//
//  RegionalMusicCache.swift
//  main
//
//  Created by Music Discovery Map Feature
//

import Foundation
import Combine

/// Cache manager for regional music data
@MainActor
class RegionalMusicCache: ObservableObject {
    static let shared = RegionalMusicCache()
    
    @Published private(set) var cachedRegions: [String: RegionalMusic] = [:]
    
    private let cacheExpirationDuration: TimeInterval = 3600 // 1 hour
    private let maxCacheSize = 50 // Maximum number of regions to cache
    
    private init() {
        loadFromDisk()
    }
    
    // MARK: - Cache Operations
    
    /// Get cached regional music data
    func get(countryCode: String) -> RegionalMusic? {
        guard let data = cachedRegions[countryCode.uppercased()] else {
            return nil
        }
        
        // Check if expired
        if data.isExpired {
            remove(countryCode: countryCode)
            return nil
        }
        
        return data
    }
    
    /// Store regional music data in cache
    func set(regionalMusic: RegionalMusic) {
        let countryCode = regionalMusic.countryCode.uppercased()
        
        // Enforce cache size limit (LRU eviction)
        if cachedRegions.count >= maxCacheSize && cachedRegions[countryCode] == nil {
            evictOldestEntry()
        }
        
        cachedRegions[countryCode] = regionalMusic
        saveToDisk()
    }
    
    /// Store multiple regional music entries
    func setMultiple(_ regionalMusicArray: [RegionalMusic]) {
        for regionalMusic in regionalMusicArray {
            let countryCode = regionalMusic.countryCode.uppercased()
            cachedRegions[countryCode] = regionalMusic
        }
        saveToDisk()
    }
    
    /// Remove a specific country from cache
    func remove(countryCode: String) {
        cachedRegions.removeValue(forKey: countryCode.uppercased())
        saveToDisk()
    }
    
    /// Clear all cached data
    func clearAll() {
        cachedRegions.removeAll()
        saveToDisk()
        print("✅ Cache cleared successfully")
    }

    /// Force clear cache (useful for debugging)
    func forceClearCache() {
        cachedRegions.removeAll()
        // Also delete the file
        try? FileManager.default.removeItem(at: cacheFileURL)
        print("✅ Cache forcefully cleared and file deleted")
    }
    
    /// Check if country data is cached and valid
    func isCached(countryCode: String) -> Bool {
        return get(countryCode: countryCode) != nil
    }
    
    /// Get all cached country codes
    func getCachedCountryCodes() -> [String] {
        return Array(cachedRegions.keys)
    }
    
    // MARK: - Persistence
    
    private var cacheFileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("regional_music_cache.json")
    }
    
    /// Save cache to disk
    private func saveToDisk() {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(cachedRegions)
            try data.write(to: cacheFileURL)
        } catch {
            print("❌ Failed to save cache to disk: \(error)")
        }
    }
    
    /// Load cache from disk
    private func loadFromDisk() {
        guard FileManager.default.fileExists(atPath: cacheFileURL.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: cacheFileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            cachedRegions = try decoder.decode([String: RegionalMusic].self, from: data)
            
            // Remove expired entries
            removeExpiredEntries()
        } catch {
            print("❌ Failed to load cache from disk: \(error)")
        }
    }
    
    // MARK: - Cache Management
    
    /// Remove expired entries from cache
    private func removeExpiredEntries() {
        let expiredKeys = cachedRegions.filter { $0.value.isExpired }.map { $0.key }
        for key in expiredKeys {
            cachedRegions.removeValue(forKey: key)
        }
        
        if !expiredKeys.isEmpty {
            saveToDisk()
        }
    }
    
    /// Evict the oldest entry (LRU)
    private func evictOldestEntry() {
        guard let oldestKey = cachedRegions.min(by: { $0.value.fetchedAt < $1.value.fetchedAt })?.key else {
            return
        }
        cachedRegions.removeValue(forKey: oldestKey)
    }
}

