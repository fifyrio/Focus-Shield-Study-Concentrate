import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    Text("Focus User")
                        .font(.title2)
                    Text("Free Plan")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                HStack(spacing: 40) {
                    VStack {
                        Text("2")
                            .font(.headline)
                        Text("Decks")
                            .font(.caption)
                    }
                    VStack {
                        Text("47")
                            .font(.headline)
                        Text("Cards")
                            .font(.caption)
                    }
                    VStack {
                        Text("2")
                            .font(.headline)
                        Text("To Unlock")
                            .font(.caption)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))

                Section {
                    NavigationLink("Upgrade to Pro") { UpgradeView() }
                    NavigationLink("Help Center") { HelpView() }
                    NavigationLink("Privacy Policy") { PrivacyView() }
                    NavigationLink("Terms of Use") { TermsView() }
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { ProfileView() }
}
