import SwiftUI

struct ProfileView: View {
    var body: some View {
        WebView(htmlFileName: "Profile")
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView()
}
