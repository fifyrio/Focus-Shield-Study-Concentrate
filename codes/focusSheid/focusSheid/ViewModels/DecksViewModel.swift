import SwiftUI
import Foundation
import Combine

class DecksViewModel: ObservableObject {
    @Published var decks: [Deck] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedDeck: Deck?
    
    private let deckService: DeckService
    private var cancellables = Set<AnyCancellable>()
    
    init(deckService: DeckService = DeckService()) {
        self.deckService = deckService
        setupBindings()
    }
    
    private func setupBindings() {
        deckService.$decks
            .assign(to: \.decks, on: self)
            .store(in: &cancellables)
    }
    
    func addDeck(_ deck: Deck) {
        deckService.addDeck(deck)
    }
    
    func deleteDeck(at indexSet: IndexSet) {
        deckService.deleteDeck(at: indexSet)
    }
    
    func updateDeckProgress(deckId: UUID, newMastered: Int) {
        deckService.updateDeckProgress(deckId: deckId, newMastered: newMastered)
    }
    
    func selectDeck(_ deck: Deck) {
        selectedDeck = deck
    }
    
    func getDeck(by id: UUID) -> Deck? {
        return deckService.getDeck(by: id)
    }
    
    var totalCards: Int {
        deckService.totalCards
    }
    
    var totalMastered: Int {
        deckService.totalMastered
    }
    
    var overallProgress: Float {
        deckService.overallProgress
    }
    
    var formattedTotalCards: String {
        "\(totalCards)"
    }
    
    var formattedStreak: String {
        "7d"
    }
}