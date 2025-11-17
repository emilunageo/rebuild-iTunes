//
//  RingtoneCard.swift
//  main
//
//  Created by iTunes Store MVP
//

import SwiftUI

struct RingtoneCard: View {
    let ringtone: Ringtone
    let size: CGFloat
    
    init(ringtone: Ringtone, size: CGFloat = 110) {
        self.ringtone = ringtone
        self.size = size
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Waveform/Icon image
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.6),
                        Color.purple.opacity(0.6)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Waveform icon
                Image(systemName: ringtone.categoryIcon)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            .frame(width: size, height: size)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
            
            // Ringtone info
            VStack(alignment: .leading, spacing: 4) {
                Text(ringtone.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                if let artist = ringtone.artist {
                    Text(artist)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack(spacing: 4) {
                    Text(ringtone.priceFormatted)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    
                    Text("•")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(ringtone.durationFormatted)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: size, alignment: .leading)
        }
        .frame(width: size)
    }
}

#Preview {
    HStack(spacing: 16) {
        RingtoneCard(
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
        
        RingtoneCard(
            ringtone: Ringtone(
                id: "2",
                title: "Classic Bell",
                artist: nil,
                category: .classic,
                price: 0.99,
                imageURL: "waveform",
                durationMs: 25000
            )
        )
    }
    .padding()
}

