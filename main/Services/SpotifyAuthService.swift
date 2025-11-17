//
//  SpotifyAuthService.swift
//  main
//
//  Created by iTunes Store MVP
//

import Foundation
import Combine

/// Handles Spotify OAuth 2.0 Client Credentials Flow authentication
@MainActor
class SpotifyAuthService: ObservableObject {
    static let shared = SpotifyAuthService()
    
    @Published private(set) var isAuthenticated = false
    
    private var accessToken: String?
    private var tokenExpirationDate: Date?
    
    private init() {}
    
    /// Get a valid access token, refreshing if necessary
    func getAccessToken() async throws -> String {
        // Check if we have a valid token
        if let token = accessToken,
           let expirationDate = tokenExpirationDate,
           Date() < expirationDate {
            return token
        }
        
        // Need to fetch a new token
        return try await fetchAccessToken()
    }
    
    /// Fetch a new access token from Spotify
    private func fetchAccessToken() async throws -> String {
        let url = URL(string: SpotifyConfig.authURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create Basic Auth header
        let credentials = "\(SpotifyConfig.clientID):\(SpotifyConfig.clientSecret)"
        guard let credentialsData = credentials.data(using: .utf8) else {
            throw SpotifyAuthError.invalidCredentials
        }
        let base64Credentials = credentialsData.base64EncodedString()
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Set body
        let bodyString = "grant_type=client_credentials"
        request.httpBody = bodyString.data(using: .utf8)
        
        // Make request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SpotifyAuthError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw SpotifyAuthError.authenticationFailed(statusCode: httpResponse.statusCode)
        }
        
        // Parse response
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        
        // Store token and expiration
        self.accessToken = tokenResponse.accessToken
        self.tokenExpirationDate = Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn - 60)) // Refresh 60 seconds early
        self.isAuthenticated = true
        
        return tokenResponse.accessToken
    }
    
    /// Clear stored authentication
    func clearAuthentication() {
        accessToken = nil
        tokenExpirationDate = nil
        isAuthenticated = false
    }
}

// MARK: - Response Models

private struct TokenResponse: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

// MARK: - Errors

enum SpotifyAuthError: LocalizedError {
    case invalidCredentials
    case invalidResponse
    case authenticationFailed(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid Spotify API credentials"
        case .invalidResponse:
            return "Invalid response from Spotify authentication server"
        case .authenticationFailed(let statusCode):
            return "Spotify authentication failed with status code: \(statusCode)"
        }
    }
}

