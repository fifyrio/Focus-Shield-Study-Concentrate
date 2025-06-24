import SwiftUI

struct DecksView: View {
    var body: some View {
        WebView(htmlFileName: "Decks")
            .navigationTitle("Decks")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DecksView()
}
