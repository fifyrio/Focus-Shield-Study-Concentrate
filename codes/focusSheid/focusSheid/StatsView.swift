import SwiftUI

struct StatsView: View {
    var body: some View {
        WebView(htmlFileName: "Stats")
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    StatsView()
}
