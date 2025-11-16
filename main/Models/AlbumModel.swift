//
//  models.swift
//  main
//
//  Created by Emiliano Luna George on 12/11/25.
//

import Foundation

struct Album: Identifiable {
    let id = UUID()
    let artistName: String
    let albumName: String
    let imageName: String
    let isExplicit: Bool
}
