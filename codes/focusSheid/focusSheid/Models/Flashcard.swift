import Foundation

public struct Flashcard: Identifiable, Codable, Hashable, Equatable {
    public let id: UUID
    public var prompt: String
    public var answer: String
    public var hint: String
    public var isCorrect: Bool = false
    public var attempts: Int = 0
    public var lastReviewed: Date?
    
    public init(prompt: String, answer: String, hint: String = "") {
        self.id = UUID()
        self.prompt = prompt
        self.answer = answer
        self.hint = hint
        self.lastReviewed = Date()
    }
    
    public mutating func markAttempt(correct: Bool) {
        attempts += 1
        isCorrect = correct
        lastReviewed = Date()
    }
    
    public static func == (lhs: Flashcard, rhs: Flashcard) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}