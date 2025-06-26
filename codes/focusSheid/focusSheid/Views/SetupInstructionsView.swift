import SwiftUI

struct SetupInstructionsView: View {
    @Environment(\.dismiss) private var dismiss
    let appName: String
    
    @State private var currentStep = 0
    @State private var isShortcutCopied = false
    
    private var setupSteps: [SetupStep] {
        [
            SetupStep(
                number: 1,
                title: "Copy Custom Shortcut",
                description: "Copy the RS-\(appName.replacingOccurrences(of: " ", with: "")) shortcut URL for later use",
                actionTitle: "Copy Shortcut",
                isActionable: true
            ),
            SetupStep(
                number: 2,
                title: "Create RS-\(appName.replacingOccurrences(of: " ", with: "")) Shortcut",
                description: "Automatically create and open the RS-\(appName.replacingOccurrences(of: " ", with: "")) shortcut in iOS Shortcuts app",
                actionTitle: "Create Shortcut",
                isActionable: true
            ),
            SetupStep(
                number: 3,
                title: "Create a new Automation",
                description: "Tap the 'Automation' tab at the bottom, then tap '+' to create new automation",
                actionTitle: nil,
                isActionable: false
            ),
            SetupStep(
                number: 4,
                title: "Select \"Open App\" Automation",
                description: "Choose 'App' from the list of automation triggers and select 'Is Opened'",
                actionTitle: nil,
                isActionable: false
            ),
            SetupStep(
                number: 5,
                title: "Configure Automation Settings",
                description: "Select '\(appName)' from the app list and configure when to run",
                actionTitle: nil,
                isActionable: false
            ),
            SetupStep(
                number: 6,
                title: "Select the RS-\(appName.replacingOccurrences(of: " ", with: "")) shortcut",
                description: "Add an action, search for 'Run Shortcut', and select 'RS-\(appName.replacingOccurrences(of: " ", with: ""))' from the list",
                actionTitle: nil,
                isActionable: false
            ),
            SetupStep(
                number: 7,
                title: "Setup Complete",
                description: "Save the automation. Now the app will be blocked during focus sessions!",
                actionTitle: nil,
                isActionable: false
            )
        ]
    }
    
    init(appName: String) {
        self.appName = appName
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    progressSection
                    stepsSection
                    finishSection
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
            .navigationTitle("Setup Instructions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "gear.badge")
                .font(.system(size: 48))
                .foregroundColor(.blue)
            
            Text("Setup App Blocking")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Follow these steps to automatically block \(appName) during focus sessions")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .padding(.top, 20)
    }
    
    private var progressSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Progress")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(currentStep + 1) of \(setupSteps.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: Double(currentStep + 1), total: Double(setupSteps.count))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .scaleEffect(y: 2)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private var stepsSection: some View {
        LazyVStack(spacing: 16) {
            ForEach(setupSteps.indices, id: \.self) { index in
                SetupStepCard(
                    step: setupSteps[index],
                    isCompleted: index < currentStep,
                    isCurrent: index == currentStep,
                    appName: appName,
                    onAction: {
                        handleStepAction(for: index)
                    }
                )
            }
        }
    }
    
    private var finishSection: some View {
        VStack(spacing: 16) {
            if currentStep >= setupSteps.count - 1 {
                Button("Finish") {
                    dismiss()
                }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [Color.green, Color.green.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.green.opacity(0.3), radius: 8, x: 0, y: 4)
                )
            } else {
                Button("Next Step") {
                    withAnimation(.spring(response: 0.5)) {
                        if currentStep < setupSteps.count - 1 {
                            currentStep += 1
                        }
                    }
                }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue, Color.blue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                )
            }
        }
    }
    
    private func handleStepAction(for stepIndex: Int) {
        let step = setupSteps[stepIndex]
        
        switch stepIndex {
        case 0: // Copy Custom Shortcut
            copyCustomShortcut()
        case 1: // Open Shortcuts App
            openShortcutsApp()
        default:
            break
        }
        
        // Auto-advance to next step after action
        if stepIndex == currentStep && currentStep < setupSteps.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.5)) {
                    currentStep += 1
                }
            }
        }
    }
    
    private func copyCustomShortcut() {
        let shortcutName = "RS-\(appName.replacingOccurrences(of: " ", with: ""))"
        let shortcutURL = "shortcuts://run-shortcut?name=\(shortcutName)"
        UIPasteboard.general.string = shortcutURL
        isShortcutCopied = true
        
        // Show feedback (could be improved with a toast)
        print("Shortcut URL copied: \(shortcutURL)")
    }
    
    private func openShortcutsApp() {
        createAndOpenShortcut()
    }
    
    private func createAndOpenShortcut() {
        let shortcutName = "RS-\(appName.replacingOccurrences(of: " ", with: ""))"
        
        // Create a shortcut URL that will both create and open the shortcut
        // This uses the iOS Shortcuts URL scheme to create a new shortcut
        let createShortcutURL = buildCreateShortcutURL(shortcutName: shortcutName)
        
        if let url = URL(string: createShortcutURL) {
            UIApplication.shared.open(url) { success in
                if !success {
                    // Fallback to just opening Shortcuts app
                    if let fallbackURL = URL(string: "shortcuts://") {
                        UIApplication.shared.open(fallbackURL)
                    }
                }
            }
        }
    }
    
    private func buildCreateShortcutURL(shortcutName: String) -> String {
        // Build a URL that creates a shortcut with specific actions
        // This creates a shortcut that shows a notification when the blocked app is opened
        
        let actions = [
            [
                "WFWorkflowActionIdentifier": "is.workflow.actions.notification",
                "WFWorkflowActionParameters": [
                    "WFNotificationActionTitle": "Focus Shield Active",
                    "WFNotificationActionBody": "\(appName) is blocked during focus sessions. Complete flashcards to unlock!"
                ]
            ],
            [
                "WFWorkflowActionIdentifier": "is.workflow.actions.exit",
                "WFWorkflowActionParameters": [:]
            ]
        ]
        
        // Convert actions to JSON string
        guard let jsonData = try? JSONSerialization.data(withJSONObject: actions, options: []),
              let actionsString = String(data: jsonData, encoding: .utf8) else {
            // Fallback to simple shortcuts app open
            return "shortcuts://"
        }
        
        // URL encode the actions
        let encodedActions = actionsString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Create the full URL to create a new shortcut
        let createURL = "shortcuts://create-shortcut?name=\(shortcutName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? shortcutName)&actions=\(encodedActions)"
        
        return createURL
    }
}

private struct SetupStep {
    let number: Int
    let title: String
    let description: String
    let actionTitle: String?
    let isActionable: Bool
}

private struct SetupStepCard: View {
    let step: SetupStep
    let isCompleted: Bool
    let isCurrent: Bool
    let appName: String
    let onAction: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            stepIndicator
            
            VStack(alignment: .leading, spacing: 8) {
                Text(step.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(step.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                if step.isActionable && isCurrent {
                    actionButton
                }
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(cardBackgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 2)
        )
        .scaleEffect(isCurrent ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isCurrent)
    }
    
    private var stepIndicator: some View {
        ZStack {
            Circle()
                .fill(indicatorBackgroundColor)
                .frame(width: 40, height: 40)
            
            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            } else {
                Text("\(step.number)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(indicatorTextColor)
            }
        }
    }
    
    private var actionButton: some View {
        Button(step.actionTitle ?? "") {
            onAction()
        }
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue)
        )
    }
    
    // MARK: - Computed Properties for Styling
    
    private var cardBackgroundColor: Color {
        if isCompleted {
            return Color.green.opacity(0.1)
        } else if isCurrent {
            return Color.blue.opacity(0.1)
        } else {
            return Color.white
        }
    }
    
    private var borderColor: Color {
        if isCompleted {
            return Color.green.opacity(0.3)
        } else if isCurrent {
            return Color.blue.opacity(0.3)
        } else {
            return Color.gray.opacity(0.1)
        }
    }
    
    private var borderWidth: CGFloat {
        return (isCompleted || isCurrent) ? 2 : 1
    }
    
    private var shadowColor: Color {
        if isCompleted {
            return Color.green.opacity(0.1)
        } else if isCurrent {
            return Color.blue.opacity(0.1)
        } else {
            return Color.black.opacity(0.05)
        }
    }
    
    private var shadowRadius: CGFloat {
        return (isCompleted || isCurrent) ? 12 : 8
    }
    
    private var indicatorBackgroundColor: Color {
        if isCompleted {
            return Color.green
        } else if isCurrent {
            return Color.blue
        } else {
            return Color.gray.opacity(0.2)
        }
    }
    
    private var indicatorTextColor: Color {
        return isCurrent ? .white : .secondary
    }
}

#Preview {
    SetupInstructionsView(appName: "Instagram")
}