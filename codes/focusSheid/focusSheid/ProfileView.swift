import SwiftUI

private struct MiniStat: View {
    var number: String
    var label: String
    var body: some View {
        VStack(spacing: 4) {
            Text(number)
                .font(.headline)
                .foregroundColor(Color.blue)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct MenuRow<Destination: View>: View {
    var icon: String
    var colors: [Color]
    var title: String
    var subtitle: String
    var destination: Destination
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 40, height: 40)
                    Text(icon)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
        }
    }
}

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                profileCard
                upgradeBanner
                purchaseSection
                generalSection
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
            Text("Profile")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
        }
        .padding(.top, 60)
    }

    private var profileCard: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 80, height: 80)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                Text("👤")
                    .font(.largeTitle)
            }
            Text("Focus User")
                .font(.title3.bold())
            Text("Free Plan")
                .font(.caption)
                .foregroundColor(.secondary)
            HStack {
                MiniStat(number: "2", label: "Decks")
                MiniStat(number: "47", label: "Cards")
                MiniStat(number: "2", label: "To Unlock")
            }
            .padding(.top)
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 25).fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
        )
        .overlay(
            LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                .frame(height: 4), alignment: .top
        )
    }

    private var upgradeBanner: some View {
        VStack(spacing: 8) {
            Text("Upgrade to Pro")
                .font(.headline)
                .foregroundColor(.white)
            Text("Unlock unlimited decks and premium features")
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
            Button("Get Pro") {}
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(Color.white)
                .foregroundColor(.blue)
                .clipShape(Capsule())
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
    }

    private var purchaseSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Purchase")
                .font(.headline)
                .padding(20)
            MenuRow(icon: "⭐", colors: [.pink, .orange], title: "Upgrade to Pro", subtitle: "Unlock premium features", destination: UpgradeView())
        }
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
    }

    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("General")
                .font(.headline)
                .padding(20)
            VStack(spacing: 0) {
                MenuRow(icon: "🐦", colors: [.teal, .green], title: "Follow us on X", subtitle: "Stay updated with latest features", destination: HelpView())
                Divider()
                MenuRow(icon: "❓", colors: [.blue, .green], title: "Help Center", subtitle: "Get support and answers", destination: HelpView())
                Divider()
                MenuRow(icon: "🔐", colors: [.purple, .pink], title: "Privacy Policy", subtitle: "How we protect your data", destination: PrivacyView())
                Divider()
                MenuRow(icon: "📋", colors: [.blue, .cyan], title: "Term of Use", subtitle: "Terms and conditions", destination: TermsView())
            }
            .background(Color.white)
        }
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
    }
}

#Preview {
    NavigationStack { ProfileView() }
}
