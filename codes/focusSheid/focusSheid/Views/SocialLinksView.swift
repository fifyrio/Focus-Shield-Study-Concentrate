import SwiftUI

struct SocialLinksView: View {
    @Environment(\.openURL) private var openURL
    
    private let socialLinks = [
        SocialLink(
            name: "Follow us on X",
            icon: "🐦",
            url: "https://x.com/focusshield",
            description: "Get the latest updates and tips",
            colors: [Color(red: 0.3, green: 0.85, blue: 0.8), Color(red: 0.27, green: 0.63, blue: 0.55)]
        ),
        SocialLink(
            name: "Discord Community",
            icon: "💬",
            url: "https://discord.gg/focusshield",
            description: "Join our community discussions",
            colors: [Color(red: 0.44, green: 0.47, blue: 0.78), Color(red: 0.36, green: 0.39, blue: 0.69)]
        ),
        SocialLink(
            name: "GitHub",
            icon: "⚡",
            url: "https://github.com/focusshield",
            description: "Contribute to our open source project",
            colors: [Color(red: 0.2, green: 0.2, blue: 0.2), Color(red: 0.4, green: 0.4, blue: 0.4)]
        ),
        SocialLink(
            name: "Support Email",
            icon: "📧",
            url: "mailto:support@focusshield.app",
            description: "Get help from our support team",
            colors: [Color(red: 1.0, green: 0.42, blue: 0.21), Color(red: 1.0, green: 0.58, blue: 0.0)]
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                socialLinksSection
                feedbackSection
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
        .navigationTitle("Connect with Us")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text("Stay Connected")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Follow us on social media for updates, tips, and community discussions about focus and productivity.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .padding(.top, 20)
    }
    
    private var socialLinksSection: some View {
        LazyVStack(spacing: 16) {
            ForEach(socialLinks, id: \.name) { link in
                SocialLinkCard(link: link) {
                    openSocialLink(link)
                }
            }
        }
    }
    
    private var feedbackSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("💡 Share Your Ideas")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("We love hearing from our users! Your feedback helps us improve Focus Shield.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 8) {
                    FeedbackTip(icon: "🐛", text: "Report bugs and issues")
                    FeedbackTip(icon: "💡", text: "Suggest new features")
                    FeedbackTip(icon: "⭐", text: "Share your success stories")
                    FeedbackTip(icon: "📝", text: "Request new flashcard templates")
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
    
    private func openSocialLink(_ link: SocialLink) {
        guard let url = URL(string: link.url) else { return }
        openURL(url)
    }
}

private struct SocialLink {
    let name: String
    let icon: String
    let url: String
    let description: String
    let colors: [Color]
}

private struct SocialLinkCard: View {
    let link: SocialLink
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: link.colors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: link.colors.first?.opacity(0.3) ?? .clear, radius: 8, x: 0, y: 4)
                    
                    Text(link.icon)
                        .font(.title2)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(link.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(link.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0) {
            // Handle completion
        } onPressingChanged: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }
    }
}

private struct FeedbackTip: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.body)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        SocialLinksView()
    }
}