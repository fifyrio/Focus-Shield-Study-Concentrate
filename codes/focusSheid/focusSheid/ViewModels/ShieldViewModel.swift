import SwiftUI
import Foundation
import Combine

class ShieldViewModel: ObservableObject {
    @Published var apps: [AppItem] = []
    @Published var focusTime: Int = 0
    @Published var isRunning: Bool = false
    @Published var currentDeck: Deck?
    
    private let appBlockingService: AppBlockingService
    private let focusSessionService: FocusSessionService
    private let deckService: DeckService
    private var cancellables = Set<AnyCancellable>()
    
    init(appBlockingService: AppBlockingService = AppBlockingService(),
         focusSessionService: FocusSessionService = FocusSessionService(),
         deckService: DeckService = .shared) {
        self.appBlockingService = appBlockingService
        self.focusSessionService = focusSessionService
        self.deckService = deckService
        
        setupBindings()
        setupCurrentDeck()
    }
    
    private func setupBindings() {
        appBlockingService.$apps
            .assign(to: \.apps, on: self)
            .store(in: &cancellables)
        
        focusSessionService.$focusTime
            .assign(to: \.focusTime, on: self)
            .store(in: &cancellables)
        
        focusSessionService.$isRunning
            .assign(to: \.isRunning, on: self)
            .store(in: &cancellables)
        
        focusSessionService.$currentDeck
            .assign(to: \.currentDeck, on: self)
            .store(in: &cancellables)
    }
    
    private func setupCurrentDeck() {
        currentDeck = deckService.getRandomDeck()
    }
    
    func toggleAppBlocking(for app: AppItem) {
        appBlockingService.toggleAppBlocking(for: app)
    }
    
    func startFocusSession() {
        focusSessionService.startSession(with: currentDeck)
    }
    
    func stopFocusSession() {
        focusSessionService.stopSession()
    }
    
    func unlockAppsAfterStudy() {
        appBlockingService.unlockAllApps()
    }
    
    var formattedTime: String {
        focusSessionService.formattedTime
    }
    
    var sessionProgress: Double {
        focusSessionService.progress
    }
}