import SwiftUI
import Foundation

public struct Deck: Identifiable, Codable, Hashable, Equatable {
    public let id: UUID
    public var title: String
    public var totalCards: Int
    public var mastered: Int
    public var color: Color
    public var icon: String
    public var flashcards: [Flashcard]
    
    public var progress: Float {
        guard totalCards > 0 else { return 0 }
        return Float(mastered) / Float(totalCards)
    }
    
    public init(title: String, totalCards: Int, mastered: Int, color: Color, icon: String, flashcards: [Flashcard] = []) {
        self.id = UUID()
        self.title = title
        self.totalCards = totalCards
        self.mastered = mastered
        self.color = color
        self.icon = icon
        self.flashcards = flashcards
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, totalCards, mastered, icon, flashcards
        case colorData = "color"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        totalCards = try container.decode(Int.self, forKey: .totalCards)
        mastered = try container.decode(Int.self, forKey: .mastered)
        icon = try container.decode(String.self, forKey: .icon)
        flashcards = try container.decodeIfPresent([Flashcard].self, forKey: .flashcards) ?? []
        
        let colorData = try container.decode(Data.self, forKey: .colorData)
        if let uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            color = Color(uiColor)
        } else {
            color = .blue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(totalCards, forKey: .totalCards)
        try container.encode(mastered, forKey: .mastered)
        try container.encode(icon, forKey: .icon)
        try container.encode(flashcards, forKey: .flashcards)
        
        let uiColor = UIColor(color)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .colorData)
    }
    
    public static func == (lhs: Deck, rhs: Deck) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}