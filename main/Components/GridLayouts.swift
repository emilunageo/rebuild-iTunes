//
//  GridLayouts.swift
//  main
//
//  Created by iTunes Store MVP
//

import SwiftUI

/// Reusable grid layout configurations for LazyVGrid
struct GridLayouts {
    
    /// Two-column grid with fixed spacing
    /// Ideal for: Albums, Music Videos
    static let twoColumnGrid = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    /// Three-column grid with compact spacing
    /// Ideal for: Ringtones, Compact items
    static let threeColumnGrid = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    /// Adaptive grid that adjusts based on available space
    /// Minimum item width: 160pt
    /// Ideal for: Responsive layouts, iPad support
    static let adaptiveGrid = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    /// Adaptive grid with smaller minimum width
    /// Minimum item width: 120pt
    /// Ideal for: Smaller items like ringtones
    static let adaptiveCompactGrid = [
        GridItem(.adaptive(minimum: 120), spacing: 12)
    ]
    
    /// Four-column grid for very compact items
    /// Ideal for: Icons, small thumbnails
    static let fourColumnGrid = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
}

/// Standard spacing constants for consistent layouts
struct GridSpacing {
    /// Horizontal padding for grid containers
    static let horizontalPadding: CGFloat = 16
    
    /// Vertical spacing between grid rows
    static let verticalSpacing: CGFloat = 16
    
    /// Compact vertical spacing for dense layouts
    static let compactVerticalSpacing: CGFloat = 12
    
    /// Section spacing (between different sections)
    static let sectionSpacing: CGFloat = 24
}

/// Standard card sizes for grid items
struct GridCardSize {
    /// Standard square card (1:1 aspect ratio)
    /// Used for: Albums, Artists
    static let square: CGFloat = 1.0
    
    /// Video card (16:9 aspect ratio)
    /// Used for: Music Videos
    static let video: CGFloat = 9.0 / 16.0
    
    /// Portrait card (3:4 aspect ratio)
    /// Used for: Posters, Covers
    static let portrait: CGFloat = 4.0 / 3.0
    
    /// Compact card (4:3 aspect ratio)
    /// Used for: Ringtones, Small items
    static let compact: CGFloat = 3.0 / 4.0
}

