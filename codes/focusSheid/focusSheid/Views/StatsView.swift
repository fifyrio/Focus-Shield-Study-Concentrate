import SwiftUI

private struct OverviewItem: View {
    var number: String
    var label: String
    var body: some View {
        VStack(spacing: 6) {
            Text(number)
                .font(.title.bold())
                .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
            Text(label)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
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
                .font(.title2)
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(unlocked ? .primary : .secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            unlocked ? Color.green.opacity(0.3) : Color.gray.opacity(0.2),
                            lineWidth: unlocked ? 2 : 1
                        )
                )
                .shadow(color: unlocked ? Color.green.opacity(0.1) : .black.opacity(0.05), radius: 4, x: 0, y: 2)
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
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.1))
                    .frame(width: 48, height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(0.2), lineWidth: 1)
                    )
                Text(icon)
                    .font(.title3)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                Text(desc)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                overview
                achievements
                progress
                activity
            }
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
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text("Statistics")
                .font(.largeTitle.bold())
                .foregroundColor(.primary)
            Text("Track your progress")
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
        .padding(.top, 60)
        .padding(.bottom, 20)
    }

    private var overview: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                OverviewItem(number: "\(viewModel.userStats.totalCards)", label: "Cards")
                OverviewItem(number: viewModel.formattedStreak, label: "Streak")
            }
            HStack(spacing: 12) {
                OverviewItem(number: viewModel.formattedFocusTime, label: "Focus")
                OverviewItem(number: "\(viewModel.userStats.totalDecks)", label: "Decks")
            }
        }
    }

    private var achievements: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.title2.bold())
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 12) {
                ForEach(viewModel.userStats.achievements) { achievement in
                    AchievementItem(title: achievement.title, icon: achievement.icon, unlocked: achievement.unlocked)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var progress: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Progress")
                .font(.title2.bold())
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(viewModel.userStats.weeklyProgress.indices, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.4, green: 0.49, blue: 0.92), Color(red: 0.46, green: 0.29, blue: 0.71)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 24, height: CGFloat(viewModel.userStats.weeklyProgress[i]) * 80)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 20)
        }
    }

    private var activity: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.title2.bold())
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                ForEach(viewModel.userStats.recentActivities.indices, id: \.self) { index in
                    let activity = viewModel.userStats.recentActivities[index]
                    ActivityItem(
                        icon: activity.icon,
                        title: activity.title,
                        desc: activity.description,
                        time: activity.time,
                        color: Color(activity.color.color)
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    if index < viewModel.userStats.recentActivities.count - 1 {
                        Divider()
                            .padding(.horizontal, 20)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    NavigationStack { StatsView() }
}
