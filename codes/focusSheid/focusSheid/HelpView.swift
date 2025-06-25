import SwiftUI

struct HelpView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Help Center")
                    .font(.largeTitle)
                    .bold()
                Text("Find answers to common questions about Focus Shield. If you need more assistance, contact our support team.")
                Divider()
                Text("How do I create a deck?")
                    .font(.headline)
                Text("Tap the + button on the Decks screen and enter your deck information.")
                Text("How do I start a focus session?")
                    .font(.headline)
                Text("Open the Shield screen and press Start. Your distracting apps will be blocked until the timer ends.")
                Text("Where can I manage my subscription?")
                    .font(.headline)
                Text("Navigate to the Upgrade page from your Profile to view options.")
            }
            .padding()
        }
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { HelpView() }
}
