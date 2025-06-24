import SwiftUI

struct TermsView: View {
    var body: some View {
        WebView(htmlFileName: "Terms")
            .navigationTitle("Terms")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TermsView()
}
