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

    // Use Spotify API instead of Mock API
    private let apiService = SpotifyAPIService.shared
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

        do {
            searchResults = try await apiService.search(query: query)
        } catch {
            print("Search error: \(error.localizedDescription)")
            // Show empty results on error
            searchResults = SearchResults(songs: [], albums: [], artists: [])
        }

        isSearching = false
    }

    func clearSearch() {
        searchQuery = ""
        searchResults = nil
    }
}

