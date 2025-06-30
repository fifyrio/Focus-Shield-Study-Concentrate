import SwiftUI

// MARK: - App Color Palette
extension Color {
    // MARK: - Primary Brand Colors
    static let brandPrimary = Color(red: 0.4, green: 0.49, blue: 0.92)      // #6B7DE8 - Main brand blue
    static let brandSecondary = Color(red: 0.46, green: 0.29, blue: 0.71)   // #754AB5 - Brand purple
    
    // MARK: - Semantic Colors
    static let success = Color(red: 0.2, green: 0.78, blue: 0.35)           // #33C759 - Success green
    static let successLight = Color(red: 0.19, green: 0.82, blue: 0.35)     // Lighter success green
    static let warning = Color(red: 1.0, green: 0.58, blue: 0.0)            // #FF9500 - Warning orange
    static let warningLight = Color(red: 1.0, green: 0.42, blue: 0.21)      // Lighter warning orange
    static let danger = Color.red                                           // System red
    
    // MARK: - Background Colors
    static let backgroundPrimary = Color(red: 0.96, green: 0.96, blue: 0.97) // #F5F5F7 - Light background
    static let backgroundSecondary = Color(red: 0.94, green: 0.94, blue: 0.96) // Slightly darker background
    static let backgroundTertiary = Color.white                             // Pure white for cards
    static let backgroundQuaternary = Color.gray.opacity(0.1)               // Very light gray
    
    // MARK: - Text Colors
    static let textPrimary = Color.primary                                  // Adaptive primary text
    static let textSecondary = Color.secondary                              // Adaptive secondary text
    static let textOnBrand = Color.white                                    // White text on brand colors
    
    // MARK: - Glass Effect Colors
    static let glassBackground = Color.white.opacity(0.95)
    static let glassBorder = Color.white.opacity(0.2)
    static let glassBorderStrong = Color.white.opacity(0.3)
    
    // MARK: - Shadow Colors
    static let shadowLight = Color.black.opacity(0.04)
    static let shadowMedium = Color.black.opacity(0.08)
    static let shadowStrong = Color.black.opacity(0.12)
    
    // MARK: - Accent Colors for Menu Items
    static let accentBlue = Color(red: 0.0, green: 0.48, blue: 1.0)
    static let accentBlueSecondary = Color(red: 0.35, green: 0.34, blue: 0.84)
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    static let accentTeal = Color(red: 0.3, green: 0.85, blue: 0.8)
    static let accentTealSecondary = Color(red: 0.27, green: 0.63, blue: 0.55)
    static let accentCyan = Color(red: 0.27, green: 0.71, blue: 0.82)
    static let accentGreen = Color(red: 0.59, green: 0.79, blue: 0.24)
    static let accentPurple = Color(red: 0.94, green: 0.58, blue: 0.98)
    static let accentPurpleSecondary = Color(red: 0.96, green: 0.34, blue: 0.43)
    static let accentSkyBlue = Color(red: 0.31, green: 0.68, blue: 1.0)
    static let accentAqua = Color(red: 0.0, green: 0.95, blue: 1.0)
}

// MARK: - Predefined Gradients
extension LinearGradient {
    // MARK: - Brand Gradients
    static let brandPrimary = LinearGradient(
        colors: [Color.brandPrimary, Color.brandSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let brandSubtle = LinearGradient(
        colors: [Color.brandPrimary.opacity(0.8), Color.brandSecondary.opacity(0.6)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Background Gradients  
    static let backgroundMain = LinearGradient(
        colors: [Color.backgroundPrimary, Color.backgroundQuaternary],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let backgroundProfile = LinearGradient(
        colors: [Color.backgroundPrimary, Color.backgroundSecondary],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let backgroundShield = LinearGradient(
        colors: [Color.brandPrimary, Color.brandSecondary, Color.brandPrimary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Success Gradient
    static let success = LinearGradient(
        colors: [Color.success, Color.success.opacity(0.7)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let successPulsing = LinearGradient(
        colors: [Color.success, Color.successLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Warning Gradient
    static let warning = LinearGradient(
        colors: [Color.warning, Color.warningLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Floating Button Gradients
    static let floatingButton = LinearGradient(
        colors: [Color.accentBlue, Color.accentBlueSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let addButton = LinearGradient(
        colors: [Color.accentBlue, Color.accentBlueSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Menu Item Gradients
    static let menuPink = LinearGradient(
        colors: [Color.accentPink, Color.warning],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let menuTeal = LinearGradient(
        colors: [Color.accentTeal, Color.accentTealSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let menuCyan = LinearGradient(
        colors: [Color.accentCyan, Color.accentGreen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let menuPurple = LinearGradient(
        colors: [Color.accentPurple, Color.accentPurpleSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let menuSkyBlue = LinearGradient(
        colors: [Color.accentSkyBlue, Color.accentAqua],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Radial Gradient Helpers
extension RadialGradient {
    static func whiteOverlay(center: UnitPoint, radius: CGFloat) -> RadialGradient {
        RadialGradient(
            colors: [Color.white.opacity(0.1), Color.clear],
            center: center,
            startRadius: 0,
            endRadius: radius
        )
    }
    
    static func mediumWhiteOverlay(center: UnitPoint, radius: CGFloat) -> RadialGradient {
        RadialGradient(
            colors: [Color.white.opacity(0.08), Color.clear],
            center: center,
            startRadius: 0,
            endRadius: radius
        )
    }
    
    static func lightWhiteOverlay(center: UnitPoint, radius: CGFloat) -> RadialGradient {
        RadialGradient(
            colors: [Color.white.opacity(0.06), Color.clear],
            center: center,
            startRadius: 0,
            endRadius: radius
        )
    }
}

// MARK: - Glass Morphism Modifier
extension View {
    func glassCard(cornerRadius: CGFloat = 24) -> some View {
        self
            .background(Color.glassBackground)
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.glassBorder, lineWidth: 1)
            )
            .shadow(color: Color.shadowMedium, radius: 32, x: 0, y: 8)
            .shadow(color: Color.shadowMedium, radius: 8, x: 0, y: 2)
    }
    
    func glassCardLarge(cornerRadius: CGFloat = 24) -> some View {
        self
            .background(Color.glassBackground)
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.glassBorderStrong, lineWidth: 1)
            )
            .shadow(color: Color.shadowStrong, radius: 25, x: 0, y: 8)
            .shadow(color: Color.shadowMedium, radius: 8, x: 0, y: 3)
    }
    
    func brandButton() -> some View {
        self
            .foregroundColor(.textOnBrand)
            .background(LinearGradient.brandPrimary)
            .cornerRadius(16)
    }
    
    func successButton() -> some View {
        self
            .foregroundColor(.textOnBrand)
            .background(LinearGradient.success)
            .cornerRadius(16)
    }
    
    func floatingButtonStyle() -> some View {
        self
            .background(
                Circle()
                    .fill(LinearGradient.floatingButton)
                    .shadow(color: Color.accentBlue.opacity(0.3), radius: 12, x: 0, y: 6)
                    .shadow(color: Color.accentBlue.opacity(0.4), radius: 16, x: 0, y: 4)
            )
    }
    
    func sectionBackground() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.backgroundTertiary)
                    .shadow(color: Color.shadowLight, radius: 6, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.backgroundQuaternary, lineWidth: 1)
                    )
            )
    }
}