import Foundation

struct Experiment: Identifiable, Codable {
    let id: UUID
    var element1Id: UUID
    var element2Id: UUID
    var resultElementId: UUID?
    var success: Bool
    var date: Date
    var pointsEarned: Int
}
