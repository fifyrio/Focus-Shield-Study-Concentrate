import SwiftUI

struct UpgradeView: View {
    var body: some View {
        WebView(htmlFileName: "Upgrade")
            .navigationTitle("Upgrade")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    UpgradeView()
}
