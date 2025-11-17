//
//  InfoView.swift
//  main
//
//  Created by iTunes Store MVP
//  Generic placeholder view for menu items
//

import SwiftUI

struct InfoView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .padding(.top, 100)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("This is a placeholder view for demonstration purposes.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Text("In a production app, this would contain the full \(title.lowercased()) interface.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        InfoView(title: "Account")
    }
}

