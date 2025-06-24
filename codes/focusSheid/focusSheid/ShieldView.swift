import SwiftUI

struct ShieldView: View {
    var body: some View {
        WebView(htmlFileName: "Shield")
            .navigationTitle("Shield")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ShieldView()
}
