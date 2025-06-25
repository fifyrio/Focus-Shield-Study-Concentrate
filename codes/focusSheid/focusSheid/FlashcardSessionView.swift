import SwiftUI

struct Question {
    var prompt: String
    var answer: String
    var hint: String
}

struct FlashcardSessionView: View {
    var deck: Deck
    @State private var index = 0
    @State private var showAnswer = false
    @State private var userInput = ""
    private let questions: [Question] = [
        Question(prompt: "What is the capital of France?", answer: "Paris", hint: "City of lights"),
        Question(prompt: "2 + 2 = ?", answer: "4", hint: "Basic addition"),
        Question(prompt: "Mix red and blue to get?", answer: "Purple", hint: "Secondary color")
    ]

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(deck.title)
                    .font(.headline)
                Spacer()
                Text("\(index + 1)/\(questions.count)")
                    .font(.subheadline)
            }
            ProgressView(value: Double(index + 1), total: Double(questions.count))
                .progressViewStyle(.linear)

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 200)
                VStack(spacing: 12) {
                    if showAnswer {
                        Text(questions[index].answer)
                            .font(.title2)
                            .bold()
                    } else {
                        Text(questions[index].prompt)
                            .font(.title2)
                            .bold()
                        Text(questions[index].hint)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .onTapGesture { withAnimation { showAnswer.toggle() } }

            TextField("Your answer", text: $userInput)
                .textFieldStyle(.roundedBorder)

            Button("Submit") {
                showAnswer = true
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red:0.4,green:0.49,blue:0.92,alpha:1)), Color(#colorLiteral(red:0.46,green:0.29,blue:0.71,alpha:1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }
}

//#Preview {
//    NavigationStack { FlashcardSessionView(deck: Deck(title: "Sample", totalCards: 3, mastered: 0)) }
//}
