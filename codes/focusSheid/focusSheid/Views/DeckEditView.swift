import SwiftUI

struct DeckEditView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var decksViewModel = DecksViewModel()
    @EnvironmentObject private var router: RouterPath
    
    @State private var deckTitle: String = ""
    @State private var selectedIcon: String = "📚"
    @State private var selectedColor: Color = Color.blue
    @State private var flashcards: [Flashcard] = []
    
    let existingDeck: Deck?
    
    private let availableIcons = ["📚", "📊", "🧪", "🏛️", "🗣️", "💻", "🎨", "🏃‍♂️", "🎵", "🌍"]
    private let availableColors: [Color] = [
        .blue, .green, .orange, .red, .purple, .pink, .cyan, .yellow, .indigo, .mint
    ]
    
    init(deck: Deck? = nil) {
        self.existingDeck = deck
        if let deck = deck {
            _deckTitle = State(initialValue: deck.title)
            _selectedIcon = State(initialValue: deck.icon)
            _selectedColor = State(initialValue: deck.color)
            _flashcards = State(initialValue: deck.flashcards)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    deckInfoSection
                    iconSelectionSection
                    colorSelectionSection
                    flashcardsSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.96, green: 0.96, blue: 0.97),
                        Color(red: 0.94, green: 0.94, blue: 0.96)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle(existingDeck == nil ? "Create Deck" : "Edit Deck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveDeck()
                    }
                    .fontWeight(.semibold)
                    .disabled(deckTitle.isEmpty)
                }
            }
        }
    }
    
    private var deckInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Deck Information")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Deck Name")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    TextField("Enter deck name", text: $deckTitle)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Preview")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [selectedColor, selectedColor.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 48, height: 48)
                                
                                Text(selectedIcon)
                                    .font(.title2)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(deckTitle.isEmpty ? "Deck Name" : deckTitle)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text("\(flashcards.count) cards")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
    }
    
    private var iconSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose Icon")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5), spacing: 12) {
                ForEach(availableIcons, id: \.self) { icon in
                    Button {
                        selectedIcon = icon
                    } label: {
                        Text(icon)
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedIcon == icon ? selectedColor.opacity(0.2) : Color.gray.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedIcon == icon ? selectedColor : Color.clear, lineWidth: 2)
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
    }
    
    private var colorSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose Color")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5), spacing: 12) {
                ForEach(availableColors, id: \.self) { color in
                    Button {
                        selectedColor = color
                    } label: {
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.black.opacity(0.1), lineWidth: 1)
                                    )
                                    .opacity(selectedColor == color ? 1 : 0)
                            )
                            .scaleEffect(selectedColor == color ? 1.2 : 1.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .animation(.spring(response: 0.3), value: selectedColor)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
    }
    
    private var flashcardsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Flashcards")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button {
                    if let deck = existingDeck {
                        router.navigate(to: .flashcardEdit(deck: deck, flashcard: nil))
                    } else {
                        let tempDeck = Deck(
                            title: deckTitle.isEmpty ? "New Deck" : deckTitle,
                            totalCards: flashcards.count,
                            mastered: 0,
                            color: selectedColor,
                            icon: selectedIcon,
                            flashcards: flashcards
                        )
                        router.navigate(to: .flashcardEdit(deck: tempDeck, flashcard: nil))
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(selectedColor)
                }
            }
            
            if flashcards.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "rectangle.stack.badge.plus")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    
                    Text("No flashcards yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Add your first flashcard to get started")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                )
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(flashcards.indices, id: \.self) { index in
                        FlashcardRow(
                            flashcard: flashcards[index],
                            index: index,
                            onEdit: {
                                if let deck = existingDeck {
                                    router.navigate(to: .flashcardEdit(deck: deck, flashcard: flashcards[index]))
                                } else {
                                    let tempDeck = Deck(
                                        title: deckTitle.isEmpty ? "New Deck" : deckTitle,
                                        totalCards: flashcards.count,
                                        mastered: 0,
                                        color: selectedColor,
                                        icon: selectedIcon,
                                        flashcards: flashcards
                                    )
                                    router.navigate(to: .flashcardEdit(deck: tempDeck, flashcard: flashcards[index]))
                                }
                            },
                            onDelete: {
                                flashcards.remove(at: index)
                            }
                        )
                    }
                }
            }
        }
    }
    
    private func saveDeck() {
        let newDeck = Deck(
            title: deckTitle,
            totalCards: flashcards.count,
            mastered: 0,
            color: selectedColor,
            icon: selectedIcon,
            flashcards: flashcards
        )
        
        decksViewModel.addDeck(newDeck)
        dismiss()
    }
}

private struct FlashcardRow: View {
    let flashcard: Flashcard
    let index: Int
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Q: \(flashcard.prompt)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                Text("A: \(flashcard.answer)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button {
                    onEdit()
                } label: {
                    Image(systemName: "pencil")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .frame(width: 32, height: 32)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Button {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .frame(width: 32, height: 32)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
        )
    }
}

#Preview {
    DeckEditView()
}