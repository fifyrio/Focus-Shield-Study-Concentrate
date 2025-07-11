# CLAUDE.md

## iOS 项目目录

```
./codes/focusSheid
```

## 高保真原型图
```
./previewWebs
```

## UI 线框图
```
./sketchs
```


This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Focus Shield is an iOS application built with SwiftUI that combines focus/productivity features with flashcard-based learning. The app blocks distracting apps and requires users to complete flashcards to unlock them.

## Development Commands

### Building and Running
- **Build project**: Open `codes/focusSheid/focusSheid.xcodeproj` in Xcode
- * 构建并测试
  ```bash
  cd codes/focusSheid && \
  xcodebuild \
    -scheme focusSheid \
    -sdk iphonesimulator \
    -destination id=679BA85A-0E50-4BF4-B5DC-31E0E30E85C3 \
    clean build
  ```
- * 运行 SwiftUI 预览
  直接在 Xcode Canvas 中点击 Resume
- * 代码风格 & 静态检查
  `swiftlint autocorrect --path MyApp/`
  遵循 `.swiftlint.yml` 中的规则

## Auto-commit Workflow

IMPORTANT: After successfully completing any development task, Claude should ALWAYS:

1. **Build Verification**: Run the build command to ensure code compiles successfully
2. **Auto-commit on Success**: If build succeeds, automatically commit changes with descriptive message
3. **Commit Message Format**: Use clear, concise messages describing what was implemented/fixed

### Auto-commit Rules:
- Always run build command first: `cd codes/focusSheid && xcodebuild -scheme focusSheid -sdk iphonesimulator clean build`
- If build succeeds (exit code 0), automatically run: `git add . && git commit -m "[descriptive message]"`
- Use present tense in commit messages (e.g. "Add dark mode toggle", "Fix navigation bug")
- Never commit if build fails - fix issues first
- Include both what was changed and why in commit messages

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

## 路由系统分析 (Router.swift)

### 文件位置
`/Root/Router/Router.swift`

### 核心架构

#### RouterPath 类
```swift
@MainActor
public class RouterPath: ObservableObject {
    @Published public var path: [RouterDestination] = []
    
    // 导航方法
    func navigate(to: RouterDestination)  // 推入新页面
    func pop()                           // 返回上一页
    func popToRoot()                     // 返回根页面
}
```

**设计特点:**
- 使用 `@MainActor` 确保线程安全
- `ObservableObject` + `@Published` 实现响应式 UI 更新
- 基于栈的导航管理

#### RouterDestination 枚举
应用支持的所有路由页面：

**主要功能模块:**

### 使用模式

1. **中心化路由**: 所有导航逻辑统一管理
2. **类型安全**: 编译时检查路由有效性
3. **参数传递**: 支持携带数据的路由跳转
4. **SwiftUI 集成**: 完美适配声明式 UI

### 代码规范
- 所有路由操作必须在主线程执行
- 新增页面需先在枚举中定义对应 case
- 参数化路由使用关联值传递数据
