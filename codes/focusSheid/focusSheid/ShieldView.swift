import SwiftUI

struct AppItem: Identifiable {
    let id = UUID()
    var name: String
    var icon: String
    var color: Color
    var blocked: Bool
}

private struct AppCard: View {
    var item: AppItem
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(item.color)
                    .frame(width: 56, height: 56)
                Text(item.icon)
            }
            Text(item.name)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Text(item.blocked ? "Blocked" : "Allowed")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.9))
        )
    }
}

struct ShieldView: View {
    @State private var focusTime: Int = 25
    @State private var running = false
    @State private var timer: Timer? = nil

    private let apps: [AppItem] = [
        AppItem(name: "Instagram", icon: "📷", color: Color.purple, blocked: true),
        AppItem(name: "YouTube", icon: "▶️", color: Color.red, blocked: true),
        AppItem(name: "TikTok", icon: "🎵", color: Color.pink, blocked: true),
        AppItem(name: "Facebook", icon: "👤", color: Color.blue, blocked: true)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                statusCard
                appGrid
            }
            .padding(.horizontal)
            .padding(.bottom, 80)
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red:0.4,green:0.49,blue:0.92,alpha:1)), Color(#colorLiteral(red:0.46,green:0.29,blue:0.71,alpha:1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
        .overlay(floatingButton, alignment: .bottomTrailing)
        .navigationBarHidden(true)
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text("Focus Shield")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            Text("Study & Concentrate")
                .foregroundColor(.white.opacity(0.9))
                .font(.subheadline)
        }
        .padding(.top, 60)
    }

    private var statusCard: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 14, height: 14)
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 2)
                    )
                    .shadow(radius: 4)
                Text("Active")
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
            }
            Text("My First Deck")
                .font(.headline)
            Text("1 Flashcard")
                .font(.caption)
                .foregroundColor(.secondary)
            Text("Answer flashcards to unlock apps")
                .font(.footnote)
                .foregroundColor(.primary)
                .padding(.top, 4)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.95)))
    }

    private var appGrid: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
            ForEach(apps) { app in
                AppCard(item: app)
            }
        }
    }

    private var floatingButton: some View {
        Button(action: {}) {
            Text("🎯")
                .font(.title)
                .frame(width: 56, height: 56)
                .background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .foregroundColor(.white)
                .clipShape(Circle())
        }
        .padding()
    }
}

#Preview {
    NavigationStack { ShieldView() }
}
