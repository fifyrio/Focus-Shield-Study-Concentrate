import SwiftUI
import Foundation
import Combine

class FlashcardSessionViewModel: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var showAnswer: Bool = false
    @Published var userInput: String = ""
    @Published var isSessionComplete: Bool = false
    @Published var correctAnswers: Int = 0
    @Published var totalAnswered: Int = 0
    @Published var showFeedback: Bool = false
    @Published var lastAnswerCorrect: Bool = false
    
    private let flashcardSessionService: FlashcardSessionService
    private var cancellables = Set<AnyCancellable>()
    
    init(deck: Deck, statsService: StatsService = .shared) {
        self.flashcardSessionService = FlashcardSessionService(deck: deck, statsService: statsService)
        setupBindings()
    }
    
    private func setupBindings() {
        flashcardSessionService.$currentIndex
            .assign(to: \.currentIndex, on: self)
            .store(in: &cancellables)
        
        flashcardSessionService.$correctAnswers
            .assign(to: \.correctAnswers, on: self)
            .store(in: &cancellables)
        
        flashcardSessionService.$totalAnswered
            .assign(to: \.totalAnswered, on: self)
            .store(in: &cancellables)
        
        flashcardSessionService.$isSessionComplete
            .assign(to: \.isSessionComplete, on: self)
            .store(in: &cancellables)
    }
    
    var currentFlashcard: Flashcard? {
        flashcardSessionService.currentFlashcard
    }
    
    var progress: Double {
        flashcardSessionService.progress
    }
    
    var progressText: String {
        flashcardSessionService.progressText
    }
    
    var accuracy: Double {
        flashcardSessionService.accuracy
    }
    
    func submitAnswer() {
        let isCorrect = flashcardSessionService.submitAnswer(userInput)
        lastAnswerCorrect = isCorrect
        showAnswer = true
        showFeedback = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.nextCard()
        }
    }
    
    func nextCard() {
        flashcardSessionService.nextCard()
        showAnswer = false
        userInput = ""
        showFeedback = false
    }
    
    func previousCard() {
        flashcardSessionService.previousCard()
        showAnswer = false
        userInput = ""
        showFeedback = false
    }
    
    func toggleAnswer() {
        showAnswer.toggle()
    }
    
    func skipCard() {
        flashcardSessionService.skipCard()
        showAnswer = false
        userInput = ""
        showFeedback = false
    }
    
    func resetSession() {
        flashcardSessionService.resetSession()
        showAnswer = false
        userInput = ""
        showFeedback = false
    }
}