import Foundation

struct Inventory: Codable {
    var elements: [UUID: Int]
    var totalExperiments: Int
    var successfulReactions: Int
    var totalPoints: Int

    init(
        elements: [UUID: Int] = [:],
        totalExperiments: Int = 0,
        successfulReactions: Int = 0,
        totalPoints: Int = 0
    ) {
        self.elements = elements
        self.totalExperiments = totalExperiments
        self.successfulReactions = successfulReactions
        self.totalPoints = totalPoints
    }
}
