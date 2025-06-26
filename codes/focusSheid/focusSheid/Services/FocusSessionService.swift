import Foundation
import Combine

class FocusSessionService: ObservableObject {
    @Published var focusTime: Int = 25 * 60
    @Published var isRunning: Bool = false
    @Published var currentDeck: Deck?
    
    private var timer: Timer?
    private let initialFocusTime = 25 * 60
    
    init() {
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            forName: .unlockApps,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleUnlockApps()
        }
    }
    
    func startSession(with deck: Deck? = nil) {
        currentDeck = deck
        isRunning = true
        focusTime = initialFocusTime
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTick()
        }
    }
    
    func stopSession() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        focusTime = initialFocusTime
        currentDeck = nil
    }
    
    func pauseSession() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func resumeSession() {
        guard !isRunning && focusTime > 0 else { return }
        isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTick()
        }
    }
    
    private func timerTick() {
        if focusTime > 0 {
            focusTime -= 1
        } else {
            completeSession()
        }
    }
    
    private func completeSession() {
        stopSession()
        NotificationCenter.default.post(name: .sessionCompleted, object: nil)
    }
    
    private func handleUnlockApps() {
        if isRunning {
            stopSession()
        }
    }
    
    var formattedTime: String {
        let minutes = focusTime / 60
        let seconds = focusTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var progress: Double {
        let elapsed = Double(initialFocusTime - focusTime)
        return elapsed / Double(initialFocusTime)
    }
    
    deinit {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
}

extension Notification.Name {
    static let unlockApps = Notification.Name("unlockApps")
    static let sessionCompleted = Notification.Name("sessionCompleted")
}