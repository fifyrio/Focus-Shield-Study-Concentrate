import SwiftUI

struct FlashcardEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var prompt: String = ""
    @State private var answer: String = ""
    @State private var hint: String = ""
    @State private var showPreview = false
    
    let existingFlashcard: Flashcard?
    let onSave: ((Flashcard) -> Void)?
    
    init(flashcard: Flashcard?, onSave: ((Flashcard) -> Void)? = nil) {
        self.existingFlashcard = flashcard
        self.onSave = onSave
        
        if let flashcard = flashcard {
            _prompt = State(initialValue: flashcard.prompt)
            _answer = State(initialValue: flashcard.answer)
            _hint = State(initialValue: flashcard.hint)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    if showPreview {
                        previewSection
                    } else {
                        editSection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.96, green: 0.96, blue: 0.97),
                        Color(red: 0.94, green: 0.94, blue: 0.96)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle(existingFlashcard == nil ? "Create Flashcard" : "Edit Flashcard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(showPreview ? "Edit" : "Preview") {
                            showPreview.toggle()
                        }
                        .foregroundColor(.blue)
                        
                        Button("Save") {
                            saveFlashcard()
                        }
                        .fontWeight(.semibold)
                        .disabled(prompt.isEmpty || answer.isEmpty)
                    }
                }
            }
        }
    }
    
    private var editSection: some View {
        VStack(spacing: 24) {
            promptSection
            answerSection
            hintSection
            tipsSection
        }
    }
    
    private var promptSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Question/Prompt")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("What do you want to ask?")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Enter your question here...", text: $prompt, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)
                    .font(.body)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
    }
    
    private var answerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Answer")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("What is the correct answer?")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Enter the answer here...", text: $answer, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(2...4)
                    .font(.body)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
    }
    
    private var hintSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hint (Optional)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Give learners a helpful hint")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Enter a hint...", text: $hint, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...3)
                    .font(.body)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("💡 Tips for Better Flashcards")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                TipRow(icon: "✏️", text: "Keep questions clear and specific")
                TipRow(icon: "🎯", text: "Make answers concise and exact")
                TipRow(icon: "💡", text: "Use hints to guide without giving away the answer")
                TipRow(icon: "🔄", text: "Test your flashcard by reading it aloud")
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    private var previewSection: some View {
        VStack(spacing: 24) {
            Text("Flashcard Preview")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            FlashcardPreview(
                prompt: prompt.isEmpty ? "Your question will appear here" : prompt,
                answer: answer.isEmpty ? "Your answer will appear here" : answer,
                hint: hint.isEmpty ? "Your hint will appear here" : hint
            )
        }
    }
    
    private func saveFlashcard() {
        let flashcard = Flashcard(
            prompt: prompt,
            answer: answer,
            hint: hint
        )
        onSave?(flashcard)
        dismiss()
    }
}

private struct TipRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.body)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

private struct FlashcardPreview: View {
    let prompt: String
    let answer: String
    let hint: String
    
    @State private var showingAnswer = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Flashcard
            VStack(spacing: 16) {
                if showingAnswer {
                    VStack(spacing: 12) {
                        Text("Answer")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .textCase(.uppercase)
                            .tracking(1)
                        
                        Text(answer)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                    }
                } else {
                    VStack(spacing: 12) {
                        Text("Question")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .textCase(.uppercase)
                            .tracking(1)
                        
                        Text(prompt)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                        
                        if !hint.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: "lightbulb")
                                    .foregroundColor(.orange)
                                
                                Text(hint)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .italic()
                            }
                            .padding(.top, 8)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
            )
            .onTapGesture {
                withAnimation(.spring(response: 0.3)) {
                    showingAnswer.toggle()
                }
            }
            
            // Instructions
            VStack(spacing: 8) {
                Text("Tap to flip")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 16) {
                    Label("Front", systemImage: "questionmark.circle")
                        .font(.caption)
                        .foregroundColor(showingAnswer ? .secondary : .blue)
                    
                    Label("Back", systemImage: "checkmark.circle")
                        .font(.caption)
                        .foregroundColor(showingAnswer ? .blue : .secondary)
                }
                .font(.caption)
            }
        }
    }
}

#Preview {
    FlashcardEditView(flashcard: nil) { _ in }
}