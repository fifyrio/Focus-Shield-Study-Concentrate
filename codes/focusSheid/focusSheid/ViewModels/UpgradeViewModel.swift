import SwiftUI
import Foundation

class UpgradeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var selectedPlan: PricingPlan = .yearly
    @Published var isLoading = false
    @Published var purchaseError: String?
    @Published var showingError = false
    @Published var isPurchaseSuccessful = false
    
    // MARK: - Feature Data
    let features: [UpgradeFeature] = [
        UpgradeFeature(
            icon: "sparkles",
            title: "Generate unlimited flashcards",
            subtitle: "Upload your lecture material to automatically generate flashcards",
            gradientColors: [.brandPrimary, .success]
        ),
        UpgradeFeature(
            icon: "lock.fill",
            title: "Earn your scroll",
            subtitle: "Force yourself to study by locking apps until you have completed your flashcards",
            gradientColors: [.success, .success.opacity(0.7)]
        ),
        UpgradeFeature(
            icon: "star.fill",
            title: "Study smarter and not harder",
            subtitle: "Stay focused for longer and study more. Using your social media addiction...",
            gradientColors: [.brandSecondary, .brandSecondary.opacity(0.7)]
        )
    ]
    
    // MARK: - Computed Properties
    var headerTitle: String {
        "80% of students who sign up study more in the first week."
    }
    
    var headerSubtitle: String {
        "Study an extra 11 hours each week for less than a coffee!"
    }
    
    var cancelAnytimeText: String {
        "Cancel Anytime"
    }
    
    var continueButtonText: String {
        isLoading ? "Processing..." : "Continue"
    }
    
    var isButtonDisabled: Bool {
        isLoading
    }
    
    // MARK: - Actions
    func selectPlan(_ plan: PricingPlan) {
        selectedPlan = plan
    }
    
    func purchaseSelectedPlan() {
        isLoading = true
        purchaseError = nil
        
        // Simulate purchase process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoading = false
            
            // Simulate success/failure
            if Bool.random() { // 50% success rate for demo
                self.isPurchaseSuccessful = true
                self.completePurchase()
            } else {
                self.handlePurchaseError("Purchase failed. Please try again.")
            }
        }
    }
    
    func restorePurchases() {
        isLoading = true
        
        // Simulate restore process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            
            // Simulate restore result
            if Bool.random() { // 50% success rate for demo
                self.isPurchaseSuccessful = true
                self.completePurchase()
            } else {
                self.handlePurchaseError("No purchases found to restore.")
            }
        }
    }
    
    func showTerms() {
        // Handle terms navigation
        // This would typically use a router or navigation system
        print("Show Terms")
    }
    
    func showPrivacyPolicy() {
        // Handle privacy policy navigation
        print("Show Privacy Policy")
    }
    
    func dismissError() {
        showingError = false
        purchaseError = nil
    }
    
    // MARK: - Private Methods
    private func completePurchase() {
        // Update app state to premium
        UserDefaults.standard.set(true, forKey: "is_premium_user")
        
        // Post notification for other parts of app
        NotificationCenter.default.post(
            name: NSNotification.Name("PremiumPurchased"),
            object: nil,
            userInfo: ["plan": selectedPlan.rawValue]
        )
    }
    
    private func handlePurchaseError(_ message: String) {
        purchaseError = message
        showingError = true
    }
}

// MARK: - Data Models
struct UpgradeFeature: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let gradientColors: [Color]
}

enum PricingPlan: String, CaseIterable {
    case yearly = "yearly"
    case monthly = "monthly"
    
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
    
    var badgeText: String? {
        switch self {
        case .yearly: return "3-Day Free Trial"
        case .monthly: return nil
        }
    }
    
    var savings: String? {
        switch self {
        case .yearly: return "Save 63%"
        case .monthly: return nil
        }
    }
}