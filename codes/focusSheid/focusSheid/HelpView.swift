import SwiftUI

struct HelpView: View {
    var body: some View {
        WebView(htmlFileName: "Help")
            .navigationTitle("Help")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HelpView()
}
