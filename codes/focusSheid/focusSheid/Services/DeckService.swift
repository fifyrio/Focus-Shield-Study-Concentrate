import Foundation
import SwiftUI
import Combine

class DeckService: ObservableObject {
    private let dataService: DataServiceProtocol
    private let decksKey = "userDecks"
    
    @Published var decks: [Deck] = []
    
    init(dataService: DataServiceProtocol = DataService()) {
        self.dataService = dataService
        loadDecks()
    }
    
    private func loadDecks() {
        if let savedDecks: [Deck] = dataService.load([Deck].self, forKey: decksKey) {
            self.decks = savedDecks
        } else {
            setupDefaultDecks()
        }
    }
    
    private func setupDefaultDecks() {
        let mathFlashcards = [
            Flashcard(prompt: "What is 5 × 7?", answer: "35", hint: "Multiplication"),
            Flashcard(prompt: "What is the square root of 64?", answer: "8", hint: "Perfect square")
        ]
        
        let scienceFlashcards = [
            Flashcard(prompt: "What is H2O?", answer: "Water", hint: "Two hydrogen, one oxygen"),
            Flashcard(prompt: "What is the speed of light?", answer: "299,792,458 m/s", hint: "In vacuum")
        ]
        
        decks = [
            Deck(title: "Mathematics", totalCards: 20, mastered: 12, 
                 color: Color(red: 0.0, green: 0.48, blue: 1.0), icon: "📊", 
                 flashcards: mathFlashcards),
            Deck(title: "Science Facts", totalCards: 15, mastered: 10, 
                 color: Color(red: 0.2, green: 0.78, blue: 0.35), icon: "🧪", 
                 flashcards: scienceFlashcards),
            Deck(title: "History", totalCards: 12, mastered: 5, 
                 color: Color(red: 1.0, green: 0.42, blue: 0.21), icon: "🏛️"),
            Deck(title: "Languages", totalCards: 25, mastered: 18, 
                 color: Color(red: 0.8, green: 0.2, blue: 0.8), icon: "🗣️")
        ]
        saveDecks()
    }
    
    private func saveDecks() {
        dataService.save(decks, forKey: decksKey)
    }
    
    func addDeck(_ deck: Deck) {
        decks.append(deck)
        saveDecks()
    }
    
    func deleteDeck(at indexSet: IndexSet) {
        decks.remove(atOffsets: indexSet)
        saveDecks()
    }
    
    func updateDeckProgress(deckId: UUID, newMastered: Int) {
        if let index = decks.firstIndex(where: { $0.id == deckId }) {
            decks[index].mastered = newMastered
            saveDecks()
        }
    }
    
    func getDeck(by id: UUID) -> Deck? {
        return decks.first { $0.id == id }
    }
    
    func getRandomDeck() -> Deck? {
        return decks.randomElement()
    }
    
    var totalCards: Int {
        decks.reduce(0) { $0 + $1.totalCards }
    }
    
    var totalMastered: Int {
        decks.reduce(0) { $0 + $1.mastered }
    }
    
    var overallProgress: Float {
        guard totalCards > 0 else { return 0 }
        return Float(totalMastered) / Float(totalCards)
    }
}