//
//  DownloadsView.swift
//  main
//
//  Created by iTunes Store MVP
//

import SwiftUI

struct DownloadsView: View {
    // Mock download queue
    private let mockDownloads = [
        DownloadItem(id: "1", title: "Anti-Hero", artist: "Taylor Swift", progress: 0.75, status: "Downloading..."),
        DownloadItem(id: "2", title: "Blinding Lights", artist: "The Weeknd", progress: 0.45, status: "Downloading..."),
        DownloadItem(id: "3", title: "Tití Me Preguntó", artist: "Bad Bunny", progress: 1.0, status: "Complete")
    ]
    
    var body: some View {
        List {
            ForEach(mockDownloads) { download in
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(download.title)
                                .font(.headline)
                            
                            Text(download.artist)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if download.progress < 1.0 {
                            Button(action: {}) {
                                Image(systemName: "pause.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.blue)
                            }
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.green)
                        }
                    }
                    
                    // Progress bar
                    VStack(alignment: .leading, spacing: 4) {
                        ProgressView(value: download.progress)
                            .tint(.blue)
                        
                        HStack {
                            Text(download.status)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(Int(download.progress * 100))%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Downloads")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DownloadItem: Identifiable {
    let id: String
    let title: String
    let artist: String
    let progress: Double
    let status: String
}

#Preview {
    NavigationStack {
        DownloadsView()
    }
}

