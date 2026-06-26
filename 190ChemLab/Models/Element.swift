import Foundation

struct Element: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var symbol: String
    var category: ElementCategory
    var color: String
    var properties: String
    var isDiscovered: Bool
    var emoji: String
    var createdAt: Date
}

enum ElementCategory: String, CaseIterable, Codable {
    case metal = "Metals"
    case nonMetal = "Non-metals"
    case gas = "Gases"
    case liquid = "Liquids"
    case acid = "Acids"
    case salt = "Salts"
    case base = "Bases"
    case organic = "Organic"

    var icon: String {
        switch self {
        case .metal: return "🔩"
        case .nonMetal: return "🧪"
        case .gas: return "💨"
        case .liquid: return "💧"
        case .acid: return "🧪"
        case .salt: return "🧂"
        case .base: return "🧪"
        case .organic: return "🌿"
        }
    }
}
