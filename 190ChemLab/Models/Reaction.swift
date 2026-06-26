import Foundation

struct Reaction: Identifiable, Codable, Hashable {
    let id: UUID
    var element1Id: UUID
    var element2Id: UUID
    var resultElementId: UUID
    var description: String
    var isDiscovered: Bool
    var discoveredAt: Date?
    var difficulty: ReactionDifficulty
}

enum ReactionDifficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var points: Int {
        switch self {
        case .easy: return 10
        case .medium: return 25
        case .hard: return 50
        }
    }

    var colorHex: String {
        switch self {
        case .easy: return "#06dbab"
        case .medium: return "#ffa500"
        case .hard: return "#ff2300"
        }
    }
}

enum ReactionResult {
    case failure
    case success(reaction: Reaction, element1: Element?, element2: Element?, result: Element?)
    case newDiscovery(reaction: Reaction, element1: Element?, element2: Element?, result: Element?)
}
