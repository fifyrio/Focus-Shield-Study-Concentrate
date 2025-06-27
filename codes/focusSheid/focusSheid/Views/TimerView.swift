import SwiftUI
import Foundation

private struct TimerCircle: View {
    let progress: Double
    let timeRemaining: String
    let isRunning: Bool
    
    private var progressGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.0, green: 0.48, blue: 1.0),
                Color(red: 0.35, green: 0.34, blue: 0.84)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var backgroundCircle: some View {
        Circle()
            .stroke(Color.gray.opacity(0.2), lineWidth: 12)
    }
    
    private var progressCircle: some View {
        Circle()
            .trim(from: 0, to: progress)
            .stroke(progressGradient, style: StrokeStyle(lineWidth: 12, lineCap: .round))
            .rotationEffect(.degrees(-90))
            .animation(.easeInOut(duration: 1), value: progress)
    }
    
    private var centerContent: some View {
        VStack(spacing: 8) {
            Text(timeRemaining)
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundColor(.primary)
            
            Text(isRunning ? "Focus Time" : "Paused")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
    
    var body: some View {
        ZStack {
            backgroundCircle
            progressCircle
            centerContent
        }
        .frame(width: 280, height: 280)
    }
}

private struct ControlButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    let isPrimary: Bool
    
    private var buttonGradient: LinearGradient {
        if isPrimary {
            return LinearGradient(
                colors: [
                    Color(red: 0.0, green: 0.48, blue: 1.0),
                    Color(red: 0.35, green: 0.34, blue: 0.84)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(buttonGradient)
            .shadow(
                color: isPrimary ? Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.3) : Color.gray.opacity(0.2),
                radius: 8,
                x: 0,
                y: 4
            )
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(isPrimary ? .white : .primary)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(buttonBackground)
        }
    }
}

private struct SessionInfo: View {
    let currentDeck: Deck?
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white.opacity(0.95))
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 8)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "books.vertical.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Deck")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text(currentDeck?.title ?? "No Deck Selected")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Cards")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("\(currentDeck?.flashcards.count ?? 0)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(20)
        .background(cardBackground)
    }
}

struct TimerView: View {
    @StateObject private var viewModel = ShieldViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingFlashcards = false
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.4, green: 0.49, blue: 0.92),
                Color(red: 0.46, green: 0.29, blue: 0.71),
                Color(red: 0.4, green: 0.49, blue: 0.92)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.2))
                    )
            }
            
            Spacer()
            
            Text("Focus Timer")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: { showingFlashcards = true }) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.2))
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var timerSection: some View {
        VStack(spacing: 40) {
            TimerCircle(
                progress: viewModel.sessionProgress,
                timeRemaining: viewModel.formattedTime,
                isRunning: viewModel.isRunning
            )
            
            HStack(spacing: 16) {
                ControlButton(
                    icon: viewModel.isRunning ? "pause.fill" : "play.fill",
                    title: viewModel.isRunning ? "Pause" : "Start",
                    action: {
                        if viewModel.isRunning {
                            viewModel.stopFocusSession()
                        } else {
                            viewModel.startFocusSession()
                        }
                    },
                    isPrimary: true
                )
                
                ControlButton(
                    icon: "stop.fill",
                    title: "Stop",
                    action: {
                        viewModel.stopFocusSession()
                        dismiss()
                    },
                    isPrimary: false
                )
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 30) {
                    headerSection
                    
                    timerSection
                        .padding(.top, 20)
                    
                    SessionInfo(currentDeck: viewModel.currentDeck)
                        .padding(.horizontal, 20)
                    
                    if viewModel.isRunning {
                        VStack(spacing: 12) {
                            Text("Stay focused!")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Complete flashcards to unlock your apps")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .background(backgroundGradient)
        }
        .sheet(isPresented: $showingFlashcards) {
            if let deck = viewModel.currentDeck {
                FlashcardSessionView(deck: deck)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .unlockApps)) { _ in
            viewModel.unlockAppsAfterStudy()
            dismiss()
        }
        #if os(iOS)
        .navigationBarHidden(true)
        #endif
    }
}

#Preview {
    TimerView()
}