import SwiftUI

struct UpgradeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Upgrade to Pro")
                .font(.largeTitle)
                .bold()
            Text("Unlock unlimited decks, cloud sync and more")
                .multilineTextAlignment(.center)
            Spacer()
            Button("Get Pro") {
                // purchase action
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
        .navigationTitle("Upgrade")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { UpgradeView() }
}
