# Second - Music Discovery App

A modern iOS music discovery application built with SwiftUI that integrates with the Spotify API to provide users with an immersive music browsing experience, including a unique map-based music discovery feature.

## 🎵 Features

### Core Functionality
- **Music Library**: Browse new releases, trending albums, and top songs from Spotify
- **Search**: Real-time search for songs, albums, and artists with debounced queries
- **Music Map Discovery**: Discover trending music from around the world on an interactive map
  - View popular songs by geographic location
  - Explore music trends in different countries
  - Interactive map annotations with album artwork
- **Music Videos**: Browse and watch music videos in a grid layout
- **Ringtones**: Explore and preview ringtones organized by categories
- **Audio Player**: Built-in music player with preview playback
  - Mini player bar for quick access
  - Full player view with playback controls
  - Audio session management with AVFoundation

### User Interface
- **Tab-based Navigation**: Easy access to Music, Search, Discover, Videos, Ringtones, and Account sections
- **Responsive Design**: Optimized for both iPhone and iPad
- **Pull-to-Refresh**: Update content with a simple pull gesture
- **Dark Mode Support**: Seamless integration with system appearance settings

## 📋 Requirements

- **Xcode**: 16.0 or later (Xcode 26.0.1 recommended)
- **iOS Deployment Target**: iOS 18.0 or later
- **Swift Version**: Swift 5.0
- **macOS**: macOS for development
- **Spotify API Credentials**: Required for API integration (see Installation section)

## 🚀 Installation

### 1. Clone the Repository
```bash
git clone <repository-url>
cd main
```

### 2. Configure Spotify API Credentials
The app requires Spotify API credentials to function. You'll need to:

1. Create a Spotify Developer account at [https://developer.spotify.com](https://developer.spotify.com)
2. Create a new app in the Spotify Developer Dashboard
3. Copy your Client ID and Client Secret
4. Update the credentials in `main/Config.swift`:

```swift
struct SpotifyConfig {
    static let clientID = "your_client_id_here"
    static let clientSecret = "your_client_secret_here"
    // ...
}
```

⚠️ **Security Note**: The `Config.swift` file contains sensitive credentials and should not be committed to version control in production. Consider using environment variables or secure storage solutions.

### 3. Open the Project
```bash
open main.xcodeproj
```

### 4. Build and Run
1. Select your target device or simulator in Xcode
2. Press `Cmd + R` to build and run the application
3. Grant location permissions when prompted (required for the Music Map feature)

## 💻 Usage

### Running the App
1. Launch the app on your iOS device or simulator
2. The app will automatically fetch content from Spotify on launch
3. Navigate between tabs to explore different features:
   - **Music**: Browse new releases and trending albums
   - **Search**: Search for your favorite songs, albums, or artists
   - **Discover**: Explore music on an interactive world map
   - **Videos**: Watch music videos
   - **Ringtones**: Browse and preview ringtones
   - **Account**: Access account settings and information

### Using the Music Map
1. Navigate to the "Discover" tab
2. The map will show your current location and trending songs nearby
3. Pan and zoom to explore different regions
4. Tap "Find in this area" to discover music in the visible map region
5. Tap on song annotations to view details and play previews

## 📁 Project Structure

```
main/
├── Assets.xcassets/          # App icons and image assets
├── Components/               # Reusable UI components
│   ├── AlbumCard.swift
│   ├── PlayerMiniBar.swift
│   ├── HorizontalCarousel.swift
│   └── ...
├── Models/                   # Data models
│   ├── Song.swift
│   ├── AlbumModel.swift
│   ├── Artist.swift
│   ├── MusicVideo.swift
│   ├── Ringtone.swift
│   └── SpotifyAPIModels.swift
├── Services/                 # API and business logic
│   ├── SpotifyAPIService.swift
│   ├── SpotifyAuthService.swift
│   ├── LocationManager.swift
│   └── RegionalMusicCache.swift
├── ViewModels/              # MVVM view models
│   ├── HomeViewModel.swift
│   ├── SearchViewModel.swift
│   ├── MusicMapViewModel.swift
│   ├── PlayerViewModel.swift
│   └── ...
├── Views/                   # SwiftUI views
│   ├── MusicMapView.swift
│   ├── SearchView.swift
│   ├── MusicVideosView.swift
│   ├── RingtonesView.swift
│   └── ...
├── Config.swift            # API configuration
├── ContentView.swift       # Main tab view
├── HomeView.swift         # Home screen
└── mainApp.swift          # App entry point
```

## 🛠 Technologies Used

### Frameworks & APIs
- **SwiftUI**: Modern declarative UI framework
- **MapKit**: Interactive map integration for music discovery
- **AVFoundation**: Audio playback and session management
- **Combine**: Reactive programming for data flow
- **CoreLocation**: Location services for regional music discovery

### Architecture
- **MVVM Pattern**: Model-View-ViewModel architecture
- **Async/Await**: Modern Swift concurrency
- **@MainActor**: Thread-safe UI updates
- **ObservableObject**: State management with Combine

### External APIs
- **Spotify Web API**: Music data, search, and recommendations
  - OAuth 2.0 authentication
  - RESTful API integration
  - Album, artist, and track endpoints

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2025 Emiliano Luna George

---

**Note**: This app uses the Spotify API for educational and demonstration purposes. All music data, artwork, and metadata are provided by Spotify. Preview playback is limited to 30-second clips as per Spotify's API terms.

