//
//  GirdView.swift
//  main
//
//  Created by Emiliano Luna George on 14/11/25.
//

import SwiftUI

struct GirdView: View {
    let items = 1...50
    
    let rows = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50))
    ]
    
    var body: some View {
        Grid {
            GridRow {
                Text("Hello")
                Image(systemName: "globe")
            }
            GridRow {
                Image(systemName: "hand.wave")
                Text("World")
            }
        }
    }
}

#Preview {
    GirdView()
}
