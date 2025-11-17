//
//  RingtoneDetailView.swift
//  main
//
//  Created by iTunes Store MVP
//

import SwiftUI

struct RingtoneDetailView: View {
    let ringtone: Ringtone
    @State private var similarRingtones: [Ringtone] = []
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Waveform visualization (static)
                ZStack {
                    // Gradient background
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.6),
                            Color.purple.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 250)
                    .cornerRadius(16)
                    
                    // Large waveform icon
                    Image(systemName: ringtone.categoryIcon)
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                }
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                // Ringtone info
                VStack(spacing: 16) {
                    // Title
                    Text(ringtone.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    // Artist (if available)
                    if let artist = ringtone.artist {
                        Text(artist)
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    
                    // Category badge
                    Text(ringtone.category.displayName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    Divider()
                        .padding(.horizontal, 24)
                    
                    // Metadata
                    VStack(spacing: 12) {
                        HStack {
                            Text("Duration")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(ringtone.durationFormatted)
                                .fontWeight(.medium)
                        }
                        
                        HStack {
                            Text("Price")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(ringtone.priceFormatted)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                        }
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 24)
                    
                    // Action buttons
                    VStack(spacing: 12) {
                        // Preview button (visual only)
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Preview")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        
                        // Buy button (visual only)
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "cart.fill")
                                Text("Buy for \(ringtone.priceFormatted)")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.green)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    // Similar ringtones section
                    if !similarRingtones.isEmpty {
                        Divider()
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Similar Ringtones")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal, 24)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(similarRingtones) { similar in
                                        NavigationLink(value: similar) {
                                            RingtoneCard(ringtone: similar)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadSimilarRingtones()
        }
    }
    
    private func loadSimilarRingtones() async {
        isLoading = true
        similarRingtones = await MockAPIService.shared.fetchSimilarRingtones(ringtoneId: ringtone.id)
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        RingtoneDetailView(
            ringtone: Ringtone(
                id: "1",
                title: "Electronic Pulse",
                artist: "Nsqk",
                category: .modern,
                price: 1.29,
                imageURL: "waveform",
                durationMs: 30000
            )
        )
    }
}

