import SwiftUI

struct Achievement: Identifiable {
    let id = UUID()
    var title: String
    var icon: String
    var unlocked: Bool
}

struct StatsView: View {
    private let achievements: [Achievement] = [
        Achievement(title: "First Steps", icon: "🏆", unlocked: true),
        Achievement(title: "On Fire", icon: "🔥", unlocked: true),
        Achievement(title: "Scholar", icon: "📚", unlocked: true),
        Achievement(title: "Diamond", icon: "💎", unlocked: false)
    ]
    private let weekly: [Double] = [0.6, 0.8, 0.45, 0.9, 1.2, 1.0, 1.4]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Achievements")
                    .font(.title2)
                    .bold()
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                    ForEach(achievements) { ach in
                        VStack {
                            Text(ach.icon)
                            Text(ach.title)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 8).fill(ach.unlocked ? Color.green.opacity(0.2) : Color.gray.opacity(0.2)))
                    }
                }

                Text("Weekly Progress")
                    .font(.title2)
                    .bold()
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(weekly.indices, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue)
                            .frame(width: 20, height: CGFloat(weekly[i]) * 100)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Stats")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { StatsView() }
}
