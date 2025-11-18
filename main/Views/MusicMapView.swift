//
//  MusicMapView.swift
//  main
//
//  Created by Music Discovery Map Feature
//

import SwiftUI
import MapKit

struct MusicMapView: View {
    @StateObject private var viewModel = MusicMapViewModel()
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State private var selectedAnnotation: SongAnnotation?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Map
                Map(
                    coordinateRegion: $viewModel.region,
                    showsUserLocation: true,
                    annotationItems: viewModel.annotations
                ) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        AnnotationView(annotation: annotation) {
                            selectedAnnotation = annotation
                        }
                    }
                }
                .ignoresSafeArea(edges: .top)
                .onChange(of: viewModel.region.center.latitude) { _, _ in
                    viewModel.onRegionChanged(viewModel.region)
                }
                .onChange(of: viewModel.region.center.longitude) { _, _ in
                    viewModel.onRegionChanged(viewModel.region)
                }
                
                // Loading overlay
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }
                }
                
                // "Find in this area" button
                if viewModel.showFindInAreaButton && !viewModel.isLoading {
                    VStack {
                        Button {
                            Task {
                                await viewModel.fetchDataForRegion()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("Find in this area")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.accentColor)
                            .cornerRadius(25)
                            .shadow(radius: 4)
                        }
                        .padding(.top, 60)
                        
                        Spacer()
                    }
                }
                
                // Error message
                if let error = viewModel.errorMessage {
                    VStack {
                        Spacer()
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red.opacity(0.9))
                            .cornerRadius(12)
                            .padding()
                    }
                }
            }
            .navigationTitle("Discover Music")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedAnnotation) { annotation in
                SongDetailSheet(annotation: annotation, playerViewModel: playerViewModel)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .task {
                await viewModel.loadInitialData()
            }
        }
    }
}

// MARK: - Annotation View

struct AnnotationView: View {
    let annotation: SongAnnotation
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                ZStack(alignment: .topTrailing) {
                    // Album artwork with enhanced styling
                    if let imageUrl = annotation.song.album.images.first?.url,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 3)
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
                            case .failure, .empty:
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: "music.note")
                                            .foregroundColor(.white)
                                            .font(.title3)
                                    )
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "music.note")
                                    .foregroundColor(.white)
                                    .font(.title3)
                            )
                    }

                    // "Top Song" badge indicator
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 24, height: 24)

                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    .offset(x: 4, y: -4)
                }

                // Song name (truncated)
                Text(annotation.song.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .frame(maxWidth: 80)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    )

                // Country code badge
                Text(annotation.countryCode)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color.accentColor, Color.accentColor.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Song Detail Sheet

struct SongDetailSheet: View {
    let annotation: SongAnnotation
    @ObservedObject var playerViewModel: PlayerViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Album artwork
                    if let imageUrl = annotation.song.album.images.first?.url,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 250, maxHeight: 250)
                                    .cornerRadius(12)
                                    .shadow(radius: 8)
                            case .failure, .empty:
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 250, height: 250)
                                    .cornerRadius(12)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }

                    // Song info
                    VStack(spacing: 8) {
                        Text(annotation.song.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)

                        Text(annotation.song.artistNames)
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)

                        Text(annotation.song.album.name)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)

                    // Location info
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.accentColor)
                        Text("Popular in \(annotation.countryName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(8)

                    // Play button
                    Button {
                        playerViewModel.playSong(annotation.song)
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Play Preview")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // Additional info
                    if let popularity = annotation.song.popularity {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                            Text("Popularity: \(popularity)%")
                                .font(.subheadline)
                        }
                        .foregroundColor(.secondary)
                    }

                    if annotation.song.explicit {
                        HStack {
                            Image(systemName: "e.square.fill")
                            Text("Explicit")
                                .font(.subheadline)
                        }
                        .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Trending Song")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    MusicMapView()
        .environmentObject(PlayerViewModel.shared)
}


