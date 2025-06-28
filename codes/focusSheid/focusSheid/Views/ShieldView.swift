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

private struct PulsingDot: View {
    @State private var isPulsing = false
    
    private var dotGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 0.2, green: 0.78, blue: 0.35), Color(red: 0.19, green: 0.82, blue: 0.35)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var pulseShadow: Color {
        Color(red: 0.2, green: 0.78, blue: 0.35).opacity(0.4)
    }
    
    var body: some View {
        Circle()
            .fill(dotGradient)
            .frame(width: 14, height: 14)
            .scaleEffect(isPulsing ? 1.1 : 1.0)
            .shadow(color: pulseShadow, radius: isPulsing ? 8 : 0)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isPulsing)
            .onAppear {
                isPulsing = true
            }
    }
}

private struct AppCard: View {
    var item: AppItem
    var onTap: () -> Void
    @State private var isHovered = false
    
    private var iconBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    colors: [item.color, item.color.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 56, height: 56)
            .shadow(color: item.color.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    private var cardContent: some View {
        VStack(spacing: 12) {
            ZStack {
                iconBackground
                Text(item.icon)
                    .font(.title2)
            }
            
            Text(item.name)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
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
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .padding(.horizontal, 20)
            .background(cardBackground)
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .offset(y: isHovered ? -6 : 0)
            .animation(.easeInOut(duration: 0.4), value: isHovered)
            .onTapGesture {
                onTap()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isHovered.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isHovered = false
                    }
                }
            }
    }
}

struct ShieldView: View {
    @StateObject private var viewModel = ShieldViewModel()
    @StateObject private var statsViewModel = StatsViewModel()
    @StateObject private var deckService = DeckService.shared
    @EnvironmentObject private var router: RouterPath
    
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
            .overlay(floatingButton, alignment: .bottomTrailing)
        }
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        #endif
    }
    
    private var contentSection: some View {
        VStack(spacing: 24) {
            statusCard
                .padding(.horizontal, 20)
                .offset(y: -30)
            
            appGrid
                .padding(.horizontal, 20)
                .offset(y: -30)
        }
        .padding(.bottom, 120)
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Focus Shield")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 2)
                .tracking(-0.5)
            
            Text("Study & Concentrate")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white.opacity(0.9))
                .tracking(0.2)
        }
        .padding(.top, 60)
        .padding(.bottom, 70)
    }

    private var statusCard: some View {
        GlassMorphismCard {
            statusCardContent
        }
        .onTapGesture {
            if let currentDeck = viewModel.currentDeck {
                router.navigate(to: .deckEdit(deck: currentDeck))
            }
        }
    }
    
    private var statusCardContent: some View {
        VStack(spacing: 20) {
            statusIndicator
            deckInfo
            unlockMessage
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 28)
        .frame(maxWidth: .infinity)
    }
    
    private var statusIndicator: some View {
        HStack(spacing: 12) {
            PulsingDot()
            Text(viewModel.isRunning ? "Active" : "Inactive")
                .font(.system(size: 19, weight: .semibold))
                .foregroundColor(viewModel.isRunning ? Color(red: 0.2, green: 0.78, blue: 0.35) : .gray)
                .tracking(-0.2)
        }
    }
    
    private var deckInfo: some View {
        VStack(spacing: 6) {
            Text(viewModel.currentDeck?.title ?? "No Deck")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
                .tracking(-0.3)
            
            Text("\(viewModel.currentDeck?.flashcards.count ?? 0) Flashcards")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary)
                .tracking(0.1)
        }
    }
    
    private var unlockMessageGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 1.0, green: 0.58, blue: 0.0), Color(red: 1.0, green: 0.42, blue: 0.21)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var unlockMessage: some View {
        Text("Answer flashcards to unlock apps")
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(unlockMessageGradient)
                    .shadow(color: Color(red: 1.0, green: 0.58, blue: 0.0).opacity(0.3), radius: 16, x: 0, y: 4)
            )
            .tracking(0.1)
    }

    private var appGrid: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
            ForEach(viewModel.apps) { app in
                AppCard(item: app, onTap: {
                    handleAppTap(app)
                })
            }
        }
    }
    
    private func handleAppTap(_ app: AppItem) {
        router.navigate(to: .setupInstructions(appName: app.name))
    }
    
    private var floatingButtonGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 0.0, green: 0.48, blue: 1.0), Color(red: 0.35, green: 0.34, blue: 0.84)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var floatingButtonBackground: some View {
        Circle()
            .fill(floatingButtonGradient)
            .shadow(color: Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.3), radius: 12, x: 0, y: 6)
            .shadow(color: Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.4), radius: 16, x: 0, y: 4)
    }

    private var floatingButton: some View {
        Button(action: {
            if viewModel.isRunning {
                router.navigate(to: .timerView)
            } else {
                viewModel.startFocusSession()
                router.navigate(to: .timerView)
            }
        }) {
            Text(viewModel.isRunning ? "⏱️" : "🎯")
                .font(.title)
                .frame(width: 56, height: 56)
                .background(floatingButtonBackground)
                .foregroundColor(.white)
        }
        .onLongPressGesture {
            router.navigate(to: .appSelection)
        }
        .padding()
        .onReceive(NotificationCenter.default.publisher(for: .unlockApps)) { _ in
            viewModel.unlockAppsAfterStudy()
        }
    }
}

#Preview {
    NavigationStack { ShieldView() }
}
