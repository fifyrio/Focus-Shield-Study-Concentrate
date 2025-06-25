import SwiftUI

private struct OverviewItem: View {
    var number: String
    var label: String
    var body: some View {
        VStack(spacing: 6) {
            Text(number)
                .font(.title.bold())
                .foregroundColor(Color.blue)
            Text(label)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
        )
    }
}

private struct AchievementItem: View {
    var title: String
    var icon: String
    var unlocked: Bool
    var body: some View {
        VStack(spacing: 6) {
            Text(icon)
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(unlocked ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
        )
    }
}

private struct ActivityItem: View {
    var icon: String
    var title: String
    var desc: String
    var time: String
    var color: Color
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .frame(width: 44, height: 44)
                Text(icon)
            }
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline.bold())
                Text(desc)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct StatsView: View {
    private let weekly: [Double] = [0.6, 0.8, 0.45, 0.9, 1.2, 1.0, 1.4]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                overview
                achievements
                progress
                activity
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red:0.4,green:0.49,blue:0.92,alpha:1)), Color(#colorLiteral(red:0.46,green:0.29,blue:0.71,alpha:1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text("Statistics")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            Text("Track your progress")
                .foregroundColor(.white.opacity(0.9))
                .font(.subheadline)
        }
        .padding(.top, 60)
    }

    private var overview: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                OverviewItem(number: "102", label: "Cards")
                OverviewItem(number: "14d", label: "Streak")
            }
            HStack(spacing: 12) {
                OverviewItem(number: "5h", label: "Focus")
                OverviewItem(number: "6", label: "Decks")
            }
        }
    }

    private var achievements: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Achievements")
                .font(.title2.bold())
                .foregroundColor(.white)
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 12) {
                AchievementItem(title: "First Steps", icon: "🏆", unlocked: true)
                AchievementItem(title: "On Fire", icon: "🔥", unlocked: true)
                AchievementItem(title: "Scholar", icon: "📚", unlocked: true)
                AchievementItem(title: "Diamond", icon: "💎", unlocked: false)
            }
        }
    }

    private var progress: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Weekly Progress")
                .font(.title2.bold())
                .foregroundColor(.white)
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(weekly.indices, id: \.
self) { i in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 20, height: CGFloat(weekly[i]) * 100)
                }
            }
        }
    }

    private var activity: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Activity")
                .font(.title2.bold())
                .foregroundColor(.white)
            VStack {
                ActivityItem(icon: "📖", title: "Completed Mathematics Deck", desc: "15 cards • 92%", time: "2h ago", color: Color.blue)
                ActivityItem(icon: "🔓", title: "Unlocked Instagram", desc: "After session", time: "3h ago", color: Color.green)
                ActivityItem(icon: "🔥", title: "7-Day Streak", desc: "Great job!", time: "1d ago", color: Color.orange)
            }
            .background(
                RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.9))
            )
        }
    }
}

#Preview {
    NavigationStack { StatsView() }
}
