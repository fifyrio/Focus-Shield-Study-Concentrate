import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Decks") { DecksView() }
                NavigationLink("Flashcard Session") { FlashcardSessionView() }
                NavigationLink("Help") { HelpView() }
                NavigationLink("Privacy") { PrivacyView() }
                NavigationLink("Profile") { ProfileView() }
                NavigationLink("Shield") { ShieldView() }
                NavigationLink("Stats") { StatsView() }
                NavigationLink("Terms") { TermsView() }
                NavigationLink("Upgrade") { UpgradeView() }
            }
            .navigationTitle("Focus Shield")
        }
    }
}

#Preview {
    ContentView()
}
