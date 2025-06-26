import Foundation
import Combine

class StatsService: ObservableObject {
    @Published var userStats: UserStats
    
    private let dataService: DataServiceProtocol
    private let statsKey = "userStats"
    
    init(dataService: DataServiceProtocol = DataService()) {
        self.dataService = dataService
        
        if let savedStats: UserStats = dataService.load(UserStats.self, forKey: statsKey) {
            self.userStats = savedStats
        } else {
            self.userStats = UserStats()
            saveStats()
        }
    }
    
    private func saveStats() {
        dataService.save(userStats, forKey: statsKey)
    }
    
    func updateCardCount(_ count: Int) {
        userStats.totalCards = count
        saveStats()
    }
    
    func updateDeckCount(_ count: Int) {
        userStats.totalDecks = count
        saveStats()
    }
    
    func incrementStreak() {
        userStats.streakDays += 1
        saveStats()
    }
    
    func resetStreak() {
        userStats.streakDays = 0
        saveStats()
    }
    
    func addFocusTime(_ hours: Float) {
        userStats.focusTimeHours += hours
        saveStats()
    }
    
    func addActivity(_ activity: Activity) {
        userStats.recentActivities.insert(activity, at: 0)
        if userStats.recentActivities.count > 10 {
            userStats.recentActivities.removeLast()
        }
        saveStats()
    }
    
    func unlockAchievement(title: String) {
        if let index = userStats.achievements.firstIndex(where: { $0.title == title }) {
            if !userStats.achievements[index].unlocked {
                userStats.achievements[index] = Achievement(
                    title: title, 
                    icon: userStats.achievements[index].icon, 
                    unlocked: true
                )
                saveStats()
            }
        }
    }
    
    func updateWeeklyProgress(dayIndex: Int, value: Double) {
        guard dayIndex >= 0 && dayIndex < userStats.weeklyProgress.count else { return }
        userStats.weeklyProgress[dayIndex] = value
        saveStats()
    }
    
    func recordFlashcardSession(correct: Int, total: Int, deckTitle: String) {
        let accuracy = total > 0 ? Double(correct) / Double(total) : 0.0
        let activity = Activity(
            icon: "🧠",
            title: "Flashcard Session",
            description: "\(correct)/\(total) correct in \(deckTitle)",
            time: "Just now",
            color: .blue
        )
        addActivity(activity)
        
        if accuracy >= 0.8 {
            unlockAchievement(title: "High Scorer")
        }
        
        if userStats.streakDays == 0 {
            incrementStreak()
        }
    }
}