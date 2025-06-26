import SwiftUI
import Foundation

struct AppItem: Identifiable, Codable {
    let id = UUID()
    var name: String
    var icon: String
    var color: Color
    var blocked: Bool
    
    init(name: String, icon: String, color: Color, blocked: Bool = true) {
        self.name = name
        self.icon = icon
        self.color = color
        self.blocked = blocked
    }
    
    enum CodingKeys: String, CodingKey {
        case name, icon, blocked
        case colorData = "color"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        icon = try container.decode(String.self, forKey: .icon)
        blocked = try container.decode(Bool.self, forKey: .blocked)
        
        let colorData = try container.decode(Data.self, forKey: .colorData)
        color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)?.swiftUIColor ?? .blue
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(blocked, forKey: .blocked)
        
        let uiColor = UIColor(color)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .colorData)
    }
}

extension UIColor {
    var swiftUIColor: Color {
        return Color(self)
    }
}