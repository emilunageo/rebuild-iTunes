//
//  HorizontalCarousel.swift
//  main
//
//  Created by Emiliano Luna George on 16/11/25.
//

import SwiftUI

/// Generic horizontal carousel component with smooth scrolling
struct HorizontalCarousel<Content: View>: View {
    let title: String
    let showSeeAll: Bool
    let content: Content
    let onSeeAllTapped: (() -> Void)?
    
    init(
        title: String,
        showSeeAll: Bool = false,
        onSeeAllTapped: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.showSeeAll = showSeeAll
        self.onSeeAllTapped = onSeeAllTapped
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if showSeeAll {
                    Button(action: {
                        onSeeAllTapped?()
                    }) {
                        Text("See All")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    content
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    HorizontalCarousel(title: "New Releases", showSeeAll: true) {
        ForEach(0..<5) { index in
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.3))
                .frame(width: 150, height: 150)
        }
    }
}

