import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .bold()
                Text("Focus Shield collects minimal data to operate. We never sell your personal information.")
                Text("Information We Collect")
                    .font(.headline)
                Text(" App usage data for blocking functionality\n Flashcard content you create\n Study session statistics")
                Text("How We Use Information")
                    .font(.headline)
                Text("Your data is used to provide core features like app blocking and progress tracking.")
                Text("Contact Us")
                    .font(.headline)
                Text("Email privacy@focusshield.app for any questions regarding this policy.")
            }
            .padding()
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { PrivacyView() }
}
