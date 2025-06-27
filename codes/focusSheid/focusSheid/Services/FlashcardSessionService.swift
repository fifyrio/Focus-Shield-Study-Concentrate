import Foundation
import Combine

class FlashcardSessionService: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var correctAnswers: Int = 0
    @Published var totalAnswered: Int = 0
    @Published var isSessionComplete: Bool = false
    
    private var deck: Deck
    private var flashcards: [Flashcard]
    private let statsService: StatsService?
    
    init(deck: Deck, statsService: StatsService? = .shared) {
        self.deck = deck
        self.flashcards = deck.flashcards
        self.statsService = statsService
    }
    
    var currentFlashcard: Flashcard? {
        guard currentIndex < flashcards.count else { return nil }
        return flashcards[currentIndex]
    }
    
    var progress: Double {
        guard flashcards.count > 0 else { return 0 }
        return Double(currentIndex + 1) / Double(flashcards.count)
    }
    
    var progressText: String {
        return "\(currentIndex + 1)/\(flashcards.count)"
    }
    
    var accuracy: Double {
        guard totalAnswered > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalAnswered)
    }
    
    func submitAnswer(_ answer: String) -> Bool {
        guard let currentCard = currentFlashcard else { return false }
        
        let isCorrect = answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == 
                       currentCard.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isCorrect {
            correctAnswers += 1
        }
        totalAnswered += 1
        
        flashcards[currentIndex].markAttempt(correct: isCorrect)
        
        return isCorrect
    }
    
    func nextCard() {
        if currentIndex < flashcards.count - 1 {
            currentIndex += 1
        } else {
            completeSession()
        }
    }
    
    func previousCard() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
    
    func skipCard() {
        totalAnswered += 1
        nextCard()
    }
    
    func completeSession() {
        isSessionComplete = true
        statsService?.recordFlashcardSession(
            correct: correctAnswers,
            total: totalAnswered,
            deckTitle: deck.title
        )
        
        if accuracy >= 0.8 {
            NotificationCenter.default.post(name: .unlockApps, object: nil)
        }
    }
    
    func resetSession() {
        currentIndex = 0
        isSessionComplete = false
        correctAnswers = 0
        totalAnswered = 0
    }
}