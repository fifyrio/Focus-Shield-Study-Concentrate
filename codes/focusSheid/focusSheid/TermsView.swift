import SwiftUI

struct TermsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Terms of Use")
                    .font(.largeTitle)
                    .bold()
                Text("By using Focus Shield you agree to these terms. Do not use the app if you disagree.")
                Text("Description of Service")
                    .font(.headline)
                Text("Focus Shield blocks distracting apps and tracks your study progress. A Pro subscription unlocks premium features.")
                Text("User Responsibilities")
                    .font(.headline)
                Text("Use the app for lawful purposes and respect intellectual property rights.")
                Text("Contact Information")
                    .font(.headline)
                Text("For questions email legal@focusshield.app")
            }
            .padding()
        }
        .navigationTitle("Terms")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { TermsView() }
}
