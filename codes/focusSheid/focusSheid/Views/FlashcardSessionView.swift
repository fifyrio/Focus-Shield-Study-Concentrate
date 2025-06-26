import SwiftUI

struct FlashcardSessionView: View {
    let deck: Deck
    @StateObject private var viewModel: FlashcardSessionViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(deck: Deck) {
        self.deck = deck
        self._viewModel = StateObject(wrappedValue: FlashcardSessionViewModel(deck: deck))
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(deck.title)
                    .font(.headline)
                Spacer()
                Text(viewModel.progressText)
                    .font(.subheadline)
            }
            ProgressView(value: viewModel.progress)
                .progressViewStyle(.linear)

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 200)
                VStack(spacing: 12) {
                    if viewModel.showAnswer {
                        Text(viewModel.currentFlashcard?.answer ?? "")
                            .font(.title2)
                            .bold()
                    } else {
                        Text(viewModel.currentFlashcard?.prompt ?? "")
                            .font(.title2)
                            .bold()
                        Text(viewModel.currentFlashcard?.hint ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .onTapGesture { 
                withAnimation { 
                    viewModel.toggleAnswer() 
                } 
            }

            TextField("Your answer", text: $viewModel.userInput)
                .textFieldStyle(.roundedBorder)

            HStack {
                Button("Submit") {
                    viewModel.submitAnswer()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.userInput.isEmpty)
                
                Button("Skip") {
                    viewModel.skipCard()
                }
                .buttonStyle(.bordered)
            }
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.4, green: 0.49, blue: 0.92), Color(red: 0.46, green: 0.29, blue: 0.71)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .alert("Session Complete!", isPresented: $viewModel.isSessionComplete) {
            Button("Continue") {
                dismiss()
            }
            Button("Retry") {
                viewModel.resetSession()
            }
        } message: {
            Text("Accuracy: \(Int(viewModel.accuracy * 100))%")
        }
    }
}

//#Preview {
//    NavigationStack { FlashcardSessionView(deck: Deck(title: "Sample", totalCards: 3, mastered: 0)) }
//}
