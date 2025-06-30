import SwiftUI


private struct MiniStat: View {
    var number: String
    var label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(number)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.brandPrimary)
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ProfileMenuRow: View {
    var icon: String
    var colors: [Color]
    var title: String
    var subtitle: String
    let action: () -> Void
    @State private var isPressed = false
    
    private var iconBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                LinearGradient(
                    colors: colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 40, height: 40)
            .shadow(color: colors.first?.opacity(0.3) ?? .clear, radius: 8, x: 0, y: 4)
    }
    
    private var menuIcon: some View {
        ZStack {
            iconBackground
            Text(icon)
                .font(.system(size: 20))
        }
    }
    
    private var menuContent: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            Text(subtitle)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
    
    private var rowContent: some View {
        HStack(spacing: 15) {
            menuIcon
            menuContent
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
    
    private var rowBackground: some View {
        Color.white
            .overlay(
                Rectangle()
                    .fill(Color.gray.opacity(0.06))
                    .frame(height: 0.5),
                alignment: .bottom
            )
    }
    
    var body: some View {
        Button(action: action) {
            rowContent
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .background(rowBackground)
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPressed)
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

private struct PremiumBanner: View {
    @State private var sparkleAnimation = false
    
    private var bannerGradient: LinearGradient {
        LinearGradient.brandPrimary
    }
    
    private var bannerBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(bannerGradient)
            .shadow(color: Color.brandPrimary.opacity(0.3), radius: 16, x: 0, y: 8)
    }
    
    private var sparkleIcon: some View {
        Text("✨")
            .font(.title2)
            .scaleEffect(sparkleAnimation ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: sparkleAnimation)
    }
    
    private var bannerText: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("Upgrade to Pro")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Text("Unlock unlimited decks and premium features")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.trailing)
        }
    }
    
    private var bannerContent: some View {
        HStack {
            sparkleIcon
            Spacer()
            bannerText
            Spacer()
        }
    }
    
    private var proButton: some View {
        Button("Get Pro") {
            // TODO: Implement navigation to upgrade view
        }
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(Color.brandPrimary)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(Color.white)
                .shadow(color: Color.shadowMedium, radius: 4, x: 0, y: 2)
        )
    }
    
    var body: some View {
        VStack(spacing: 12) {
            bannerContent
            proButton
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(bannerBackground)
        .onAppear {
            sparkleAnimation = true
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject private var router: RouterPath
    
    private var backgroundGradient: LinearGradient {
        LinearGradient.backgroundProfile
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
            .background(
                backgroundGradient
                    .ignoresSafeArea()
            )
        }
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        #endif
    }
    
    private var contentSection: some View {
        VStack(spacing: 24) {
            profileCard
                .padding(.horizontal, 20)
                .offset(y: -20)
            
            PremiumBanner()
                .padding(.horizontal, 20)
                .offset(y: -20)
            
            purchaseSection
                .padding(.horizontal, 20)
                .offset(y: -20)
            
            generalSection
                .padding(.horizontal, 20)
                .offset(y: -20)
        }
        .padding(.bottom, 100)
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Profile")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
                .tracking(-0.5)
        }
        .padding(.top, 60)
        .padding(.bottom, 40)
    }

    private var profileCard: some View {
        profileCardContent
            .glassCard(cornerRadius: 25)
    }
    
    private var avatarGradient: LinearGradient {
        LinearGradient.brandPrimary
    }
    
    private var avatar: some View {
        ZStack {
            Circle()
                .fill(avatarGradient)
                .frame(width: 80, height: 80)
                .shadow(color: Color.brandPrimary.opacity(0.3), radius: 10, x: 0, y: 5)
            
            Text("👤")
                .font(.system(size: 32))
        }
    }
    
    private var userInfo: some View {
        VStack(spacing: 5) {
            Text("Focus User")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            
            Text("Free Plan")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.gray.opacity(0.1))
                )
        }
    }
    
    private var stats: some View {
        HStack(spacing: 0) {
            MiniStat(number: "2", label: "Decks")
            MiniStat(number: "47", label: "Cards")
            MiniStat(number: "2", label: "To Unlock")
        }
        .padding(.top, 10)
    }
    
    private var topGradientLine: some View {
        LinearGradient.brandPrimary
        .frame(height: 4)
        .clipShape(RoundedRectangle(cornerRadius: 2))
    }
    
    private var profileCardContent: some View {
        VStack(spacing: 20) {
            avatar
            userInfo
            stats
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .overlay(topGradientLine, alignment: .top)
    }

    private var purchaseSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle("Purchase")
            
            VStack(spacing: 0) {
                ProfileMenuRow(
                    icon: "⭐",
                    colors: [Color.accentPink, Color.warning],
                    title: "Upgrade to Pro",
                    subtitle: "Unlock premium features"
                ) {
                    router.navigate(to: .upgradeView)
                }
            }
            .sectionBackground()
        }
    }

    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle("General")
            
            VStack(spacing: 0) {
                ProfileMenuRow(
                    icon: "🐦",
                    colors: [Color.accentTeal, Color.accentTealSecondary],
                    title: "Follow us on X",
                    subtitle: "Stay updated with latest features"
                ) {
                    router.navigate(to: .socialLinksView)
                }
                
                ProfileMenuRow(
                    icon: "❓",
                    colors: [Color.accentCyan, Color.accentGreen],
                    title: "Help Center",
                    subtitle: "Get support and answers"
                ) {
                    router.navigate(to: .helpView)
                }
                
                ProfileMenuRow(
                    icon: "🔐",
                    colors: [Color.accentPurple, Color.accentPurpleSecondary],
                    title: "Privacy Policy",
                    subtitle: "How we protect your data"
                ) {
                    router.navigate(to: .privacyView)
                }
                
                ProfileMenuRow(
                    icon: "📋",
                    colors: [Color.accentSkyBlue, Color.accentAqua],
                    title: "Terms of Use",
                    subtitle: "Terms and conditions"
                ) {
                    router.navigate(to: .termsView)
                }
            }
            .sectionBackground()
        }
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.primary)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
    }
    
}

#Preview {
    NavigationStack { ProfileView() }
}
