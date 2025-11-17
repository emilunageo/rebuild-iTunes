//
//  PurchasedView.swift
//  main
//
//  Created by iTunes Store MVP
//

import SwiftUI

struct PurchasedView: View {
    // Mock purchased items
    private let mockPurchases = [
        PurchasedItem(id: "1", title: "Midnight Dreams", artist: "Nsqk", type: "Song", date: "Nov 15, 2024", price: "$1.29"),
        PurchasedItem(id: "2", title: "ATP", artist: "Nsqk", type: "Album", date: "Nov 10, 2024", price: "$9.99"),
        PurchasedItem(id: "3", title: "Superpowers", artist: "Daniel Caesar", type: "Song", date: "Nov 5, 2024", price: "$1.29"),
        PurchasedItem(id: "4", title: "Electronic Pulse", artist: "Nsqk", type: "Ringtone", date: "Nov 1, 2024", price: "$1.29"),
        PurchasedItem(id: "5", title: "Bien o Mal", artist: "Trueno", type: "Album", date: "Oct 28, 2024", price: "$9.99")
    ]
    
    var body: some View {
        List {
            ForEach(mockPurchases) { purchase in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(purchase.title)
                                .font(.headline)
                            
                            Text(purchase.artist)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(purchase.price)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                            
                            Text(purchase.type)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text(purchase.date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Purchased")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PurchasedItem: Identifiable {
    let id: String
    let title: String
    let artist: String
    let type: String
    let date: String
    let price: String
}

#Preview {
    NavigationStack {
        PurchasedView()
    }
}

