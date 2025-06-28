import SwiftUI

private struct GlassMorphismCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.white.opacity(0.95))
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
            )
    }
    
    private var cardShadows: some View {
        cardBackground
            .shadow(color: .black.opacity(0.12), radius: 32, x: 0, y: 8)
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
    
    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: 24)
            .stroke(Color.white.opacity(0.2), lineWidth: 1)
    }
    
    var body: some View {
        content
            .background(
                cardShadows
                    .overlay(cardBorder)
            )
    }
}

private struct StatItem: View {
    var value: String
    var label: String
    
    private var statBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 0.4, green: 0.49, blue: 0.92).opacity(0.1), lineWidth: 1)
            )
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                .tracking(-0.3)
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
                .tracking(0.1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(statBackground)
    }
}

private struct AnimatedProgressBar: View {
    let progress: Float
    let color: Color
    @State private var animatedProgress: Float = 0
    
    private var progressBackground: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.2))
            .frame(height: 6)
    }
    
    private func progressFill(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(
                LinearGradient(
                    colors: [color, color.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width * CGFloat(animatedProgress), height: 6)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                progressBackground
                progressFill(width: geometry.size.width)
            }
        }
        .frame(height: 6)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).delay(0.2)) {
                animatedProgress = progress
            }
        }
    }
}

private struct DeckCard: View {
    var deck: Deck
    @State private var isHovered = false
    @State private var isPressed = false
    var onStudy: (() -> Void)? = nil
    var onEdit: (() -> Void)? = nil
    
    private var deckIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [deck.color, deck.color.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 44, height: 44)
                .shadow(color: deck.color.opacity(0.3), radius: 8, x: 0, y: 4)
            
            Text(deck.icon)
                .font(.title2)
        }
    }
    
    private var deckHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(deck.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                    .tracking(-0.2)
                
                Text("\(deck.mastered)/\(deck.totalCards) mastered")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                    .tracking(0.1)
            }
            Spacer()
            deckIcon
        }
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Progress")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(deck.progress * 100))%")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(deck.color)
            }
            
            AnimatedProgressBar(progress: deck.progress, color: deck.color)
        }
    }
    
    private var studyButtonGradient: LinearGradient {
        LinearGradient(
            colors: [deck.color, deck.color.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var studyButton: some View {
        Button("Study Now") {
            onStudy?()
        }
        .font(.system(size: 15, weight: .semibold))
        .foregroundColor(.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(studyButtonGradient)
                .shadow(color: deck.color.opacity(0.3), radius: 8, x: 0, y: 4)
        )
    }
    
    private var editButtonBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(deck.color.opacity(0.3), lineWidth: 1.5)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(deck.color.opacity(0.05))
            )
    }
    
    private var editButton: some View {
        Button("Edit") {
            onEdit?()
        }
        .font(.system(size: 15, weight: .medium))
        .foregroundColor(deck.color)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(editButtonBackground)
    }
    
    private var actionButtons: some View {
        HStack(spacing: 12) {
            studyButton
            editButton
        }
    }
    
    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            deckHeader
            progressSection
            actionButtons
        }
    }
    
    private var cardBaseBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white.opacity(0.9))
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
    }
    
    private var cardShadows: some View {
        cardBaseBackground
            .shadow(color: .black.opacity(0.08), radius: 25, x: 0, y: 8)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
    }
    
    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color.white.opacity(0.3), lineWidth: 1)
    }
    
    private var hoverOverlay: some View {
        LinearGradient(
            colors: [Color.white.opacity(0.1), Color.clear],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .opacity(isHovered ? 1 : 0)
    }
    
    private var cardBackground: some View {
        cardShadows
            .overlay(cardBorder)
            .overlay(hoverOverlay)
    }

    var body: some View {
        cardContent
            .padding(24)
            .background(cardBackground)
            .scaleEffect(isPressed ? 0.98 : (isHovered ? 1.02 : 1.0))
            .offset(y: isHovered ? -6 : 0)
            .animation(.easeInOut(duration: 0.4), value: isHovered)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPressed)
            .onLongPressGesture(minimumDuration: 0) {
                // Handle press state changes
            } onPressingChanged: { pressing in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovered = pressing
                }
            }
    }
    
    private func performTapAnimation() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            isPressed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = false
            }
        }
    }
}

struct DecksView: View {
    @StateObject private var viewModel = DecksViewModel()
    @EnvironmentObject private var router: RouterPath
    @State private var showingDeckEdit = false
    @State private var editingDeck: Deck? = nil
    
    // Extract complex gradient background
    private func backgroundGradient(geometry: GeometryProxy) -> some View {
        LinearGradient(
            colors: [
                Color(red: 0.4, green: 0.49, blue: 0.92),
                Color(red: 0.46, green: 0.29, blue: 0.71),
                Color(red: 0.4, green: 0.49, blue: 0.92)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(radialOverlay1(geometry: geometry))
        .overlay(radialOverlay2(geometry: geometry))
        .overlay(radialOverlay3(geometry: geometry))
        .ignoresSafeArea()
    }
    
    private func radialOverlay1(geometry: GeometryProxy) -> some View {
        RadialGradient(
            colors: [Color.white.opacity(0.1), Color.clear],
            center: UnitPoint(x: 0.2, y: 0.2),
            startRadius: 0,
            endRadius: geometry.size.width * 0.5
        )
    }
    
    private func radialOverlay2(geometry: GeometryProxy) -> some View {
        RadialGradient(
            colors: [Color.white.opacity(0.08), Color.clear],
            center: UnitPoint(x: 0.8, y: 0.4),
            startRadius: 0,
            endRadius: geometry.size.width * 0.5
        )
    }
    
    private func radialOverlay3(geometry: GeometryProxy) -> some View {
        RadialGradient(
            colors: [Color.white.opacity(0.06), Color.clear],
            center: UnitPoint(x: 0.4, y: 0.8),
            startRadius: 0,
            endRadius: geometry.size.width * 0.5
        )
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                        .frame(maxWidth: .infinity)
                    
                    contentSection
                }
            }
            .background(backgroundGradient(geometry: geometry))
        }
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        #endif
        .sheet(isPresented: $showingDeckEdit) {
            DeckEditView(deck: editingDeck)
        }
    }
    
    private var contentSection: some View {
        VStack(spacing: 24) {
            statsBar
                .padding(.horizontal, 20)
                .offset(y: -30)
            
            sectionHeader
                .padding(.horizontal, 24)
                .offset(y: -30)
            
            decksList
                .padding(.horizontal, 20)
                .offset(y: -30)
        }
        .padding(.bottom, 120)
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Flashcard Decks")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 2)
                .tracking(-0.5)
            
            Text("Choose a deck to study")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white.opacity(0.9))
                .tracking(0.2)
        }
        .padding(.top, 60)
        .padding(.bottom, 70)
    }

    private var statsBar: some View {
        GlassMorphismCard {
            HStack(spacing: 20) {
                StatItem(value: "\(viewModel.decks.count)", label: "Decks")
                StatItem(value: viewModel.formattedTotalCards, label: "Cards")
                StatItem(value: viewModel.formattedStreak, label: "Streak")
            }
            .padding(24)
        }
    }
    
    private var addButtonGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 0.0, green: 0.48, blue: 1.0), Color(red: 0.35, green: 0.34, blue: 0.84)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var addButtonBackground: some View {
        Circle()
            .fill(addButtonGradient)
            .shadow(color: Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.3), radius: 12, x: 0, y: 4)
    }
    
    private var sectionHeader: some View {
        HStack {
            Text("My Decks")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .tracking(-0.4)
            
            Spacer()
            
            Button(action: {
                editingDeck = nil
                showingDeckEdit = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(addButtonBackground)
            }
            .scaleEffect(1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: 1.0)
        }
    }
    
    private var decksList: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.decks) { deck in
                DeckCard(
                    deck: deck,
                    onStudy: {
                        router.navigate(to: .flashcardSession(deck: deck))
                    },
                    onEdit: {
                        editingDeck = deck
                        showingDeckEdit = true
                    }
                )
            }
        }
    }
}

#Preview {
    NavigationStack { DecksView() }
}
