import SwiftUI

struct UpgradeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: PricingPlan = .yearly
    
    private let purpleGradient = LinearGradient(
        colors: [Color(red: 0.4, green: 0.49, blue: 0.92), Color(red: 0.7, green: 0.6, blue: 0.98)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    featuresSection
                    pricingSection
                    continueButton
                    footerLinks
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Color.gray.opacity(0.1))
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("80% of students who sign up study more in the first week.")
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                
                Text("Study an extra 11 hours each week for less than a coffee!")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(LinearGradient(
                                colors: [Color(red: 0.3, green: 0.6, blue: 0.7), Color(red: 0.2, green: 0.5, blue: 0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                    )
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 32)
        .padding(.bottom, 40)
    }
    
    private var featuresSection: some View {
        VStack(spacing: 0) {
            FeatureRow(
                icon: "sparkles",
                title: "Generate unlimited flashcards",
                subtitle: "Upload your lecture material to automatically generate flashcards",
                gradientColors: [Color(red: 0.4, green: 0.49, blue: 0.92), Color(red: 0.0, green: 0.8, blue: 0.7)]
            )
            
            FeatureRow(
                icon: "lock.fill",
                title: "Earn your scroll",
                subtitle: "Force yourself to study by locking apps until you have completed your flashcards",
                gradientColors: [Color(red: 0.0, green: 0.8, blue: 0.7), Color(red: 0.4, green: 0.9, blue: 0.8)]
            )
            
            FeatureRow(
                icon: "star.fill",
                title: "Study smarter and not harder",
                subtitle: "Stay focused for longer and study more. Using your social media addiction...",
                gradientColors: [Color(red: 0.4, green: 0.9, blue: 0.8), Color(red: 0.6, green: 1.0, blue: 0.9)]
            )
        }
        .padding(.bottom, 40)
    }
    
    private var pricingSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.green)
                Text("Cancel Anytime")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 12) {
                PricingCard(
                    plan: .yearly,
                    isSelected: selectedPlan == .yearly,
                    badgeText: "3-Day Free Trial"
                ) {
                    selectedPlan = .yearly
                }
                
                PricingCard(
                    plan: .monthly,
                    isSelected: selectedPlan == .monthly
                ) {
                    selectedPlan = .monthly
                }
            }
        }
        .padding(.bottom, 32)
    }
    
    private var continueButton: some View {
        Button {
            // Handle purchase
        } label: {
            Text("Continue")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [Color(red: 0.3, green: 0.6, blue: 0.7), Color(red: 0.2, green: 0.5, blue: 0.6)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                )
        }
        .padding(.bottom, 24)
    }
    
    private var footerLinks: some View {
        HStack(spacing: 40) {
            Button("Restore Purchases") {
                // Handle restore
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
            
            Button("Terms") {
                // Handle terms
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
            
            Button("Privacy") {
                // Handle privacy
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradientColors: [Color]
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Rectangle()
                    .fill(LinearGradient(
                        colors: gradientColors,
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .frame(width: 4)
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 40, height: 40)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(gradientColors.first ?? .blue)
                    }
                    
                    Spacer()
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(.bottom, 32)
    }
}

enum PricingPlan: CaseIterable {
    case yearly, monthly
    
    var title: String {
        switch self {
        case .yearly: return "Yearly"
        case .monthly: return "Monthly"
        }
    }
    
    var price: String {
        switch self {
        case .yearly: return "¥14.00/mo"
        case .monthly: return "¥38.00/mo"
        }
    }
    
    var billingInfo: String {
        switch self {
        case .yearly: return "Billed at ¥168.00/yr."
        case .monthly: return "Billed at ¥38.00/mo."
        }
    }
}

struct PricingCard: View {
    let plan: PricingPlan
    let isSelected: Bool
    let badgeText: String?
    let onTap: () -> Void
    
    init(plan: PricingPlan, isSelected: Bool, badgeText: String? = nil, onTap: @escaping () -> Void) {
        self.plan = plan
        self.isSelected = isSelected
        self.badgeText = badgeText
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                if let badge = badgeText {
                    Text(badge)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(LinearGradient(
                                    colors: [Color(red: 0.3, green: 0.6, blue: 0.7), Color(red: 0.2, green: 0.5, blue: 0.6)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                        )
                        .offset(y: -8)
                }
                
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(plan.title)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text(plan.price)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text(plan.billingInfo)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .stroke(isSelected ? Color(red: 0.4, green: 0.49, blue: 0.92) : Color.secondary.opacity(0.3), lineWidth: 2)
                                .frame(width: 24, height: 24)
                            
                            if isSelected {
                                Circle()
                                    .fill(Color(red: 0.4, green: 0.49, blue: 0.92))
                                    .frame(width: 16, height: 16)
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color(red: 0.4, green: 0.49, blue: 0.92) : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack { UpgradeView() }
}
