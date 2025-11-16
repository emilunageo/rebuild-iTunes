//
//  SearchViewModel.swift
//  main
//
//  Created by Emiliano Luna George on 16/11/25.
//

import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var searchResults: SearchResults?
    @Published var isSearching = false
    
    private let apiService = MockAPIService.shared
    private var searchTask: Task<Void, Never>?
    
    init() {
        // Debounce search
        Task {
            for await query in $searchQuery.values {
                searchTask?.cancel()
                
                guard !query.isEmpty else {
                    searchResults = nil
                    continue
                }
                
                searchTask = Task {
                    try? await Task.sleep(nanoseconds: 300_000_000) // 300ms debounce
                    
                    guard !Task.isCancelled else { return }
                    
                    await performSearch(query: query)
                }
            }
        }
    }
    
    private func performSearch(query: String) async {
        isSearching = true
        searchResults = await apiService.search(query: query)
        isSearching = false
    }
    
    func clearSearch() {
        searchQuery = ""
        searchResults = nil
    }
}

