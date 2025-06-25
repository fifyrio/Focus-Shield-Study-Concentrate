import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack { ShieldView() }
                .tabItem {
                    Image(systemName: "shield.lefthalf.fill")
                    Text("Shield")
                }

            NavigationStack { DecksView() }
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Decks")
                }

            NavigationStack { StatsView() }
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Stats")
                }

            NavigationStack { ProfileView() }
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView()
}
