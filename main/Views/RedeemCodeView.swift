//
//  RedeemCodeView.swift
//  main
//
//  Created by iTunes Store MVP
//

import SwiftUI

struct RedeemCodeView: View {
    @State private var code: String = ""
    @State private var showingAlert = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Icon
            Image(systemName: "giftcard.fill")
                .font(.system(size: 80))
                .foregroundColor(.red)
                .padding(.top, 60)
            
            // Title
            Text("Redeem Gift Card or Code")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // Description
            Text("Enter your gift card or promo code to add credit to your Apple ID")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            // Code input
            VStack(alignment: .leading, spacing: 8) {
                Text("Code")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Enter code", text: $code)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
            }
            .padding(.horizontal, 32)
            .padding(.top, 16)
            
            // Redeem button (visual only)
            Button(action: {
                showingAlert = true
            }) {
                Text("Redeem")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(code.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(12)
            }
            .disabled(code.isEmpty)
            .padding(.horizontal, 32)
            
            // Camera button
            Button(action: {}) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Use Camera")
                }
                .foregroundColor(.blue)
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .navigationTitle("Redeem")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Demo Mode", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("This is a visual-only demo. No actual redemption will occur.")
        }
    }
}

#Preview {
    NavigationStack {
        RedeemCodeView()
    }
}

