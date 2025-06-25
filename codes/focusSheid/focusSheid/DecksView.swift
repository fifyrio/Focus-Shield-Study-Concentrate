import SwiftUI

struct Deck: Identifiable {
    let id = UUID()
    var title: String
    var totalCards: Int
    var mastered: Int
}

private struct StatItem: View {
    var value: String
    var label: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundColor(Color.blue)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.7))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

private struct DeckCard: View {
    var deck: Deck

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(deck.title)
                        .font(.headline)
                    Text("\(deck.mastered)/\(deck.totalCards) mastered")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }

            ProgressView(value: Float(deck.mastered), total: Float(deck.totalCards))
                .progressViewStyle(.linear)
                .tint(.blue)

            HStack {
                Button("Study Now") {}
                    .buttonStyle(.borderedProminent)
                Button("Edit") {}
                    .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.9))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
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
            VStack(spacing: 24) {
                header
                stats
                    .padding(.horizontal)

                VStack(spacing: 16) {
                    ForEach(decks) { deck in
                        NavigationLink(destination: FlashcardSessionView(deck: deck)) {
                            DeckCard(deck: deck)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red:0.4,green:0.49,blue:0.92,alpha:1)), Color(#colorLiteral(red:0.46,green:0.29,blue:0.71,alpha:1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text("Flashcard Decks")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            Text("Choose a deck to study")
                .foregroundColor(.white.opacity(0.9))
                .font(.subheadline)
        }
        .padding(.top, 60)
        .padding(.bottom, 40)
    }

    private var stats: some View {
        HStack(spacing: 12) {
            StatItem(value: "3", label: "Decks")
            StatItem(value: "47", label: "Cards")
            StatItem(value: "7d", label: "Streak")
        }
    }
}

#Preview {
    NavigationStack { DecksView() }
}
