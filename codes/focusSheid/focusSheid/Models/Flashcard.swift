import Foundation

struct Flashcard: Identifiable, Codable {
    let id = UUID()
    var prompt: String
    var answer: String
    var hint: String
    var isCorrect: Bool = false
    var attempts: Int = 0
    var lastReviewed: Date?
    
    init(prompt: String, answer: String, hint: String = "") {
        self.prompt = prompt
        self.answer = answer
        self.hint = hint
        self.lastReviewed = Date()
    }
    
    mutating func markAttempt(correct: Bool) {
        attempts += 1
        isCorrect = correct
        lastReviewed = Date()
    }
}