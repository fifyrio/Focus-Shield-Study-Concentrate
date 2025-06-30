import SwiftUI

struct UpgradeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = UpgradeViewModel()
    
    
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
            .background(Color.backgroundPrimary)
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
                Text(viewModel.headerTitle)
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                
                Text(viewModel.headerSubtitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(LinearGradient.success)
                    )
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 32)
        .padding(.bottom, 40)
    }
    
    private var featuresSection: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.features) { feature in
                FeatureRow(
                    icon: feature.icon,
                    title: feature.title,
                    subtitle: feature.subtitle,
                    gradientColors: feature.gradientColors
                )
            }
        }
        .padding(.bottom, 40)
    }
    
    private var pricingSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.green)
                Text(viewModel.cancelAnytimeText)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 12) {
                ForEach(PricingPlan.allCases, id: \.self) { plan in
                    PricingCard(
                        plan: plan,
                        isSelected: viewModel.selectedPlan == plan,
                        badgeText: plan.badgeText
                    ) {
                        viewModel.selectPlan(plan)
                    }
                }
            }
        }
        .padding(.bottom, 32)
    }
    
    private var continueButton: some View {
        Button {
            viewModel.purchaseSelectedPlan()
        } label: {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.white)
                }
                Text(viewModel.continueButtonText)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient.brandPrimary)
                    .opacity(viewModel.isButtonDisabled ? 0.6 : 1.0)
            )
        }
        .disabled(viewModel.isButtonDisabled)
        .padding(.bottom, 24)
    }
    
    private var footerLinks: some View {
        HStack(spacing: 40) {
            Button("Restore Purchases") {
                viewModel.restorePurchases()
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.brandPrimary)
            .disabled(viewModel.isLoading)
            
            Button("Terms") {
                viewModel.showTerms()
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.brandPrimary)
            
            Button("Privacy") {
                viewModel.showPrivacyPolicy()
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.brandPrimary)
        }
        .alert("Purchase Error", isPresented: $viewModel.showingError) {
            Button("OK") {
                viewModel.dismissError()
            }
        } message: {
            Text(viewModel.purchaseError ?? "An error occurred")
        }
        .alert("Purchase Successful!", isPresented: $viewModel.isPurchaseSuccessful) {
            Button("Continue") {
                dismiss()
            }
        } message: {
            Text("Welcome to Premium! Enjoy unlimited access to all features.")
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
                                .fill(LinearGradient.success)
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
                                .stroke(isSelected ? Color.brandPrimary : Color.secondary.opacity(0.3), lineWidth: 2)
                                .frame(width: 24, height: 24)
                            
                            if isSelected {
                                Circle()
                                    .fill(Color.brandPrimary)
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
                            .stroke(isSelected ? Color.brandPrimary : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack { UpgradeView() }
}
