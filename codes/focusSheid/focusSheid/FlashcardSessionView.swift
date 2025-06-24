import SwiftUI

struct FlashcardSessionView: View {
    var body: some View {
        WebView(htmlFileName: "FlashcardSession")
            .navigationTitle("FlashcardSession")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FlashcardSessionView()
}
