//
//  TermsView.swift
//  main
//
//  Created by iTunes Store MVP
//

import SwiftUI

struct TermsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Terms & Conditions")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                
                Text("Last Updated: November 16, 2024")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Divider()
                
                Group {
                    SectionHeader(title: "1. Acceptance of Terms")
                    SectionText(text: "By accessing and using this iTunes Store MVP application, you accept and agree to be bound by the terms and provision of this agreement. This is a demonstration application for educational purposes only.")
                    
                    SectionHeader(title: "2. Use License")
                    SectionText(text: "This is a mock application created for demonstration purposes. No actual purchases, downloads, or transactions will occur. All content is simulated using mock data.")
                    
                    SectionHeader(title: "3. Disclaimer")
                    SectionText(text: "This application is provided 'as is' without any representations or warranties, express or implied. This is not an official Apple product and is not affiliated with Apple Inc., iTunes, or Apple Music.")
                    
                    SectionHeader(title: "4. Mock Data")
                    SectionText(text: "All songs, albums, artists, music videos, and ringtones displayed in this application are mock data for demonstration purposes. No actual media files are included or playable (except for a single preview audio file if added).")
                    
                    SectionHeader(title: "5. No Purchases")
                    SectionText(text: "This application does not process any real purchases or payments. All prices, purchase buttons, and transaction flows are visual-only demonstrations.")
                    
                    SectionHeader(title: "6. Privacy")
                    SectionText(text: "This application does not collect, store, or transmit any personal information. No user accounts are created, and no data is sent to external servers.")
                    
                    SectionHeader(title: "7. Intellectual Property")
                    SectionText(text: "All trademarks, service marks, and trade names referenced in this application are the property of their respective owners. This application is for educational demonstration purposes only.")
                    
                    SectionHeader(title: "8. Modifications")
                    SectionText(text: "We reserve the right to modify these terms at any time. Continued use of the application constitutes acceptance of modified terms.")
                }
            }
            .padding(24)
        }
        .navigationTitle("Terms & Conditions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .padding(.top, 8)
    }
}

struct SectionText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    NavigationStack {
        TermsView()
    }
}

