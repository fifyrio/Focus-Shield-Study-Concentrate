import SwiftUI

struct PrivacyView: View {
    var body: some View {
        WebView(htmlFileName: "Privacy")
            .navigationTitle("Privacy")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PrivacyView()
}
