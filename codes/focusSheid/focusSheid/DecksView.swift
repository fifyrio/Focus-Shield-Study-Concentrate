import SwiftUI

struct Deck: Identifiable {
    let id = UUID()
    var title: String
    var totalCards: Int
    var mastered: Int
}

struct DeckCard: View {
    var deck: Deck

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(deck.title)
                .font(.headline)
                .foregroundColor(.primary)
            ProgressView(value: Float(deck.mastered), total: Float(deck.totalCards))
                .progressViewStyle(.linear)
            HStack {
                Text("Cards: \(deck.totalCards)")
                Spacer()
                Text("Mastered: \(deck.mastered)")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

struct DecksView: View {
    @State private var decks: [Deck] = [
        Deck(title: "Mathematics", totalCards: 20, mastered: 12),
        Deck(title: "Science Facts", totalCards: 15, mastered: 10),
        Deck(title: "History", totalCards: 12, mastered: 5)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Flashcard Decks")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 8)

                ForEach(decks) { deck in
                    NavigationLink(destination: FlashcardSessionView(deck: deck)) {
                        DeckCard(deck: deck)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Decks")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { DecksView() }
}
