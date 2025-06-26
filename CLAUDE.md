# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Focus Shield is an iOS application built with SwiftUI that combines focus/productivity features with flashcard-based learning. The app blocks distracting apps and requires users to complete flashcards to unlock them.

## Development Commands

### Building and Running
- **Build project**: Open `codes/focusSheid/focusSheid.xcodeproj` in Xcode
- * 构建并测试
  `xcodebuild -scheme focusSheid -sdk iphonesimulator \  -destination 'platform=iOS Simulator,name=iPhone 16' build test`
- * 运行 SwiftUI 预览
  直接在 Xcode Canvas 中点击 Resume
- * 代码风格 & 静态检查
  `swiftlint autocorrect --path MyApp/`
  遵循 `.swiftlint.yml` 中的规则

### Project Structure
- **Main app entry**: `codes/focusSheid/focusSheid/focusSheidApp.swift`
- **Root view**: `codes/focusSheid/focusSheid/ContentView.swift` - TabView with 4 main sections
- **Core views**: Shield, Decks, Stats, Profile views in the main app directory

## Architecture

### Core App Structure
The app uses a TabView-based navigation with four main sections:
1. **ShieldView**: Main focus/blocking interface with app management
2. **DecksView**: Flashcard deck management and study interface  
3. **StatsView**: User statistics and progress tracking
4. **ProfileView**: User profile and settings

### Key Design Patterns
- **MVVM Architecture**: Complete separation of Model, View, and ViewModel layers
- **Custom UI Components**: Extensive use of custom glassmorphism cards and styling
- **State Management**: Uses `@StateObject` and `@ObservableObject` for reactive data binding
- **Data Persistence**: UserDefaults with JSON encoding/decoding for local data storage

### UI Components
- **GlassMorphismCard**: Reusable card component with glass effect styling
- **Custom animations**: Pulsing dots, hover effects, and spring animations
- **Gradient backgrounds**: Complex multi-layer gradient backgrounds with radial overlays

### Data Models (Models/)
- **AppItem**: Represents blocked/allowed applications with blocking status and color coding
- **Deck**: Flashcard deck model with progress tracking and flashcard collection
- **Flashcard**: Individual study card with prompt, answer, hint, and attempt tracking
- **UserStats**: User progress, achievements, and activity tracking
- **Achievement**: Individual achievement with unlock status
- **Activity**: Recent user activity entries
- All models implement Identifiable and Codable for persistence

### ViewModels (ViewModels/)
- **ShieldViewModel**: Manages app blocking state, focus sessions, and timer functionality
- **DecksViewModel**: Handles deck collection, CRUD operations, and progress tracking
- **StatsViewModel**: Manages user statistics, achievements, and activity history
- **FlashcardSessionViewModel**: Controls flashcard study sessions and scoring
- All ViewModels use `@Published` properties for reactive UI updates

## Important Notes

- **Xcode Version**: Built with Xcode 16.2, Swift 5.0
- **iOS Target**: iOS 18.2+
- **Bundle ID**: com.fifyrio.ai.focusSheid
- **Team ID**: ETM6Y43SU4 (configured for development)

## File Organization

```
codes/focusSheid/focusSheid/
├── focusSheidApp.swift           # App entry point
├── ContentView.swift             # Main TabView container
├── Models/                       # Data models
│   ├── AppItem.swift            # Blocked app representation
│   ├── Deck.swift               # Flashcard deck model
│   ├── Flashcard.swift          # Individual flashcard
│   └── UserStats.swift          # User statistics and achievements
├── ViewModels/                   # Business logic layer
│   ├── ShieldViewModel.swift    # Shield/blocking logic
│   ├── DecksViewModel.swift     # Deck management logic
│   ├── StatsViewModel.swift     # Statistics management
│   └── FlashcardSessionViewModel.swift # Study session logic
├── Views/                        # UI layer
│   ├── ShieldView.swift         # Focus/blocking main screen
│   ├── DecksView.swift          # Flashcard deck management
│   ├── StatsView.swift          # Statistics view
│   ├── ProfileView.swift        # Profile/settings
│   ├── FlashcardSessionView.swift # Flashcard study session
│   ├── HelpView.swift           # Help documentation
│   ├── PrivacyView.swift        # Privacy policy
│   ├── TermsView.swift          # Terms of service
│   └── UpgradeView.swift        # Premium upgrade
```

Additional directories:
- `previewWebs/`: HTML mockups/prototypes
- `sketchs/`: UI wireframes and design assets

## MVVM Implementation Notes

### Data Flow
1. **Models** define data structures and business rules
2. **ViewModels** handle business logic, data persistence, and state management
3. **Views** bind to ViewModels using `@StateObject` and `@ObservableObject`
4. **Reactive Updates** through `@Published` properties trigger UI refreshes

### Key Features
- **Data Persistence**: All user data automatically saved to UserDefaults
- **Real-time Updates**: Changes in ViewModels immediately reflect in UI
- **Session Management**: Focus sessions and flashcard progress tracking
- **Cross-View Communication**: NotificationCenter for app unlocking events
- **Error Handling**: Proper error states and user feedback

### Testing Considerations
- ViewModels can be unit tested independently
- Mock data available through ViewModel initializers
- Business logic separated from UI for easier testing
