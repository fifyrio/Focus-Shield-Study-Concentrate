import SwiftUI

// MARK: - App Color Palette
extension Color {
    // MARK: - Primary Brand Colors
    static let brandPrimary = Color(red: 0.4, green: 0.49, blue: 0.92)      // #6B7DE8 - Main brand blue
    static let brandSecondary = Color(red: 0.46, green: 0.29, blue: 0.71)   // #754AB5 - Brand purple
    
    // MARK: - Semantic Colors
    static let success = Color(red: 0.2, green: 0.78, blue: 0.35)           // #33C759 - Success green
    static let warning = Color(red: 1.0, green: 0.58, blue: 0.0)            // #FF9500 - Warning orange
    static let danger = Color.red                                           // System red
    
    // MARK: - Background Colors
    static let backgroundPrimary = Color(red: 0.96, green: 0.96, blue: 0.97) // #F5F5F7 - Light background
    static let backgroundSecondary = Color.white                            // Pure white for cards
    static let backgroundTertiary = Color.gray.opacity(0.1)                 // Very light gray
    
    // MARK: - Text Colors
    static let textPrimary = Color.primary                                  // Adaptive primary text
    static let textSecondary = Color.secondary                              // Adaptive secondary text
    static let textOnBrand = Color.white                                    // White text on brand colors
    
    // MARK: - Glass Effect Colors
    static let glassBackground = Color.white.opacity(0.95)
    static let glassBorder = Color.white.opacity(0.2)
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
    static let background = LinearGradient(
        colors: [Color.backgroundPrimary, Color.backgroundTertiary],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // MARK: - Success Gradient
    static let success = LinearGradient(
        colors: [Color.success, Color.success.opacity(0.7)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Glass Morphism Modifier
extension View {
    func glassCard() -> some View {
        self
            .background(Color.glassBackground)
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.glassBorder, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
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
}