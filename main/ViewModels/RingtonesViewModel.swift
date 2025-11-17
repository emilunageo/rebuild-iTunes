//
//  RingtonesViewModel.swift
//  main
//
//  Created by iTunes Store MVP
//

import Foundation
import Combine

@MainActor
class RingtonesViewModel: ObservableObject {
    @Published var ringtones: [Ringtone] = []
    @Published var filteredRingtones: [Ringtone] = []
    @Published var selectedCategory: RingtoneCategory?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let apiService = MockAPIService.shared
    
    init() {
        Task {
            await loadRingtones()
        }
    }
    
    /// Load all ringtones
    func loadRingtones() async {
        isLoading = true
        errorMessage = nil
        
        do {
            ringtones = await apiService.fetchRingtones()
            applyFilter()
        } catch {
            errorMessage = "Failed to load ringtones"
        }
        
        isLoading = false
    }
    
    /// Select a category to filter ringtones
    func selectCategory(_ category: RingtoneCategory?) {
        selectedCategory = category
        applyFilter()
    }
    
    /// Apply category filter
    private func applyFilter() {
        if let category = selectedCategory {
            filteredRingtones = ringtones.filter { $0.category == category }
        } else {
            filteredRingtones = ringtones
        }
    }
    
    /// Refresh ringtones (for pull-to-refresh)
    func refresh() async {
        await loadRingtones()
    }
    
    /// Get ringtone count for a specific category
    func count(for category: RingtoneCategory) -> Int {
        ringtones.filter { $0.category == category }.count
    }
}

