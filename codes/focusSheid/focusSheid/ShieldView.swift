import SwiftUI

struct ShieldView: View {
    @State private var focusTime: Int = 25
    @State private var running = false
    @State private var timer: Timer? = nil

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("🛡️")
                .font(.system(size: 80))
            Text(running ? "Focus Time: \(focusTime) min" : "Start Focus Session")
                .font(.headline)
            Button(running ? "Stop" : "Start") {
                running.toggle()
                if running {
                    startTimer()
                } else {
                    timer?.invalidate()
                }
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
        .navigationTitle("Shield")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func startTimer() {
        focusTime = 25
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            if focusTime > 0 {
                focusTime -= 1
            } else {
                timer?.invalidate()
                running = false
            }
        }
    }
}

#Preview {
    NavigationStack { ShieldView() }
}
