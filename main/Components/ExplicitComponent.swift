//
//  explicitComponent.swift
//  main
//
//  Created by Emiliano Luna George on 12/11/25.
//

import SwiftUI

struct ExplicitComponent: View {
    var body: some View {
        Text("E")
            .font(.caption2.bold())
            .foregroundColor(.primary)
            .frame(width: 14, height: 14)
            .background(Color.secondary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 2))
    }
}

#Preview {
    ExplicitComponent()
}
