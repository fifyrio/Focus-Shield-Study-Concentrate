import SwiftUI
import Foundation
import Combine

class StatsViewModel: ObservableObject {
    @Published var userStats: UserStats = UserStats()
    @Published var isLoading: Bool = false
    
    private let statsService: StatsService
    private var cancellables = Set<AnyCancellable>()
    
    init(statsService: StatsService = StatsService()) {
        self.statsService = statsService
        setupBindings()
    }
    
    private func setupBindings() {
        statsService.$userStats
            .assign(to: \.userStats, on: self)
            .store(in: &cancellables)
    }
    
    func updateCardCount(_ count: Int) {
        statsService.updateCardCount(count)
    }
    
    func updateDeckCount(_ count: Int) {
        statsService.updateDeckCount(count)
    }
    
    func incrementStreak() {
        statsService.incrementStreak()
    }
    
    func resetStreak() {
        statsService.resetStreak()
    }
    
    func addFocusTime(_ hours: Float) {
        statsService.addFocusTime(hours)
    }
    
    func addActivity(_ activity: Activity) {
        statsService.addActivity(activity)
    }
    
    func unlockAchievement(title: String) {
        statsService.unlockAchievement(title: title)
    }
    
    func updateWeeklyProgress(dayIndex: Int, value: Double) {
        statsService.updateWeeklyProgress(dayIndex: dayIndex, value: value)
    }
    
    var formattedFocusTime: String {
        if userStats.focusTimeHours < 1 {
            return "\(Int(userStats.focusTimeHours * 60))m"
        } else {
            return String(format: "%.1fh", userStats.focusTimeHours)
        }
    }
    
    var formattedStreak: String {
        return "\(userStats.streakDays)d"
    }
}