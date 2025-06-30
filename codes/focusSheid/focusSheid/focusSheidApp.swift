//
//  focusSheidApp.swift
//  focusSheid
//
//  Created by 吴伟 on 6/24/25.
//

import SwiftUI



@main
struct FocusShieldApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var routerPath = RouterPath()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(routerPath)
                .preferredColorScheme(.light)
        }
    }
}

struct RootView: View {
    
    @EnvironmentObject var appState: AppState
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen()
                    .transition(.opacity)
            } else {
                MainContentView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    showSplash = false
                }
            }
        }
    }
}

struct SplashScreen: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.7
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .blue.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "shield.lefthalf.fill")
                    .font(.system(size: 80, weight: .medium))
                    .foregroundColor(.white)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                
                VStack(spacing: 8) {
                    Text("Focus Shield")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Study & Concentrate")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.9))
                }
                .opacity(logoOpacity)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
        }
    }
}

struct MainContentView: View {
    @EnvironmentObject var routerPath: RouterPath
    
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            TabView {
                ShieldView()
                    .tabItem {
                        Image(systemName: "shield.lefthalf.fill")
                        Text("Shield")
                    }

                DecksView()
                    .tabItem {
                        Image(systemName: "books.vertical")
                        Text("Decks")
                    }

                StatsView()
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Stats")
                    }

                ProfileView()
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Profile")
                    }
            }
            .tint(.blue)
            .withAppRouter()
        }
    }
}

// MARK: - App State Management
class AppState: ObservableObject {
    @Published var isOnboardingCompleted: Bool {
        didSet {
            UserDefaults.standard.set(isOnboardingCompleted, forKey: "onboarding_completed")
        }
    }
    
    @Published var isPremiumUser: Bool {
        didSet {
            UserDefaults.standard.set(isPremiumUser, forKey: "is_premium_user")
        }
    }
    
    @Published var currentTheme: AppTheme = .system
    
    init() {
        self.isOnboardingCompleted = UserDefaults.standard.bool(forKey: "onboarding_completed")
        self.isPremiumUser = UserDefaults.standard.bool(forKey: "is_premium_user")
        
        // 设置应用首次启动默认值
        if !UserDefaults.standard.bool(forKey: "has_launched_before") {
            UserDefaults.standard.set(true, forKey: "has_launched_before")
            self.isOnboardingCompleted = false
        }
    }
    
    func completeOnboarding() {
        isOnboardingCompleted = true
    }
    
    func upgradeToPremium() {
        isPremiumUser = true
    }
}

enum AppTheme: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    
    var displayName: String {
        switch self {
        case .light: return "浅色"
        case .dark: return "深色"
        case .system: return "跟随系统"
        }
    }
}
