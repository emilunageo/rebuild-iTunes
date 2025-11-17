//
//  RingtonesView.swift
//  main
//
//  Created by iTunes Store MVP
//

import SwiftUI

struct RingtonesView: View {
    @StateObject private var viewModel = RingtonesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        // "All" category
                        CategoryChip(
                            title: "All",
                            isSelected: viewModel.selectedCategory == nil,
                            action: {
                                viewModel.selectCategory(nil)
                            }
                        )
                        
                        // Category chips
                        ForEach(RingtoneCategory.allCases, id: \.self) { category in
                            CategoryChip(
                                title: category.displayName,
                                isSelected: viewModel.selectedCategory == category,
                                action: {
                                    viewModel.selectCategory(category)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(Color(UIColor.systemBackground))
                
                Divider()
                
                // Grid content
                ScrollView {
                    if viewModel.isLoading && viewModel.ringtones.isEmpty {
                        ProgressView()
                            .padding(.top, 100)
                    } else if let errorMessage = viewModel.errorMessage {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 50))
                                .foregroundColor(.secondary)
                            Text(errorMessage)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 100)
                    } else {
                        LazyVGrid(columns: GridLayouts.threeColumnGrid, spacing: GridSpacing.verticalSpacing) {
                            ForEach(viewModel.filteredRingtones) { ringtone in
                                NavigationLink(value: ringtone) {
                                    RingtoneCard(ringtone: ringtone)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, GridSpacing.horizontalPadding)
                        .padding(.top, 16)
                    }
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }
            .navigationTitle("Ringtones")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Ringtone.self) { ringtone in
                RingtoneDetailView(ringtone: ringtone)
            }
        }
    }
}

// Category chip component
struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .cornerRadius(20)
        }
    }
}

#Preview {
    RingtonesView()
}

