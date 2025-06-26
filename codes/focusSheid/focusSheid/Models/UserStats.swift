import Foundation
import UIKit

struct UserStats: Codable {
    var totalCards: Int = 0
    var streakDays: Int = 0
    var focusTimeHours: Float = 0.0
    var totalDecks: Int = 0
    var weeklyProgress: [Double] = [0.6, 0.8, 0.45, 0.9, 1.2, 1.0, 1.4]
    var achievements: [Achievement] = []
    var recentActivities: [Activity] = []
    
    init() {
        setupDefaultAchievements()
        setupDefaultActivities()
    }
    
    private mutating func setupDefaultAchievements() {
        achievements = [
            Achievement(title: "First Steps", icon: "🏆", unlocked: true),
            Achievement(title: "On Fire", icon: "🔥", unlocked: true),
            Achievement(title: "Scholar", icon: "📚", unlocked: true),
            Achievement(title: "Diamond", icon: "💎", unlocked: false)
        ]
    }
    
    private mutating func setupDefaultActivities() {
        recentActivities = [
            Activity(icon: "📖", title: "Completed Mathematics Deck", description: "15 cards • 92%", time: "2h ago", color: .blue),
            Activity(icon: "🔓", title: "Unlocked Instagram", description: "After session", time: "3h ago", color: .green),
            Activity(icon: "🔥", title: "7-Day Streak", description: "Great job!", time: "1d ago", color: .orange)
        ]
    }
}

struct Achievement: Identifiable, Codable {
    let id = UUID()
    let title: String
    let icon: String
    let unlocked: Bool
    
    init(title: String, icon: String, unlocked: Bool) {
        self.title = title
        self.icon = icon
        self.unlocked = unlocked
    }
}

struct Activity: Identifiable, Codable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let time: String
    let color: ColorData
    
    init(icon: String, title: String, description: String, time: String, color: ColorData) {
        self.icon = icon
        self.title = title
        self.description = description
        self.time = time
        self.color = color
    }
}

enum ColorData: String, Codable, CaseIterable {
    case blue, green, orange, red, purple, yellow
    
    var color: UIColor {
        switch self {
        case .blue: return .systemBlue
        case .green: return .systemGreen
        case .orange: return .systemOrange
        case .red: return .systemRed
        case .purple: return .systemPurple
        case .yellow: return .systemYellow
        }
    }
}
