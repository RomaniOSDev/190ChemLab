import SwiftUI
import Combine

struct RecentExperimentItem: Identifiable {
    let id: UUID
    let emoji1: String
    let emoji2: String
    let resultEmoji: String?
    let success: Bool
    let points: Int
    let date: Date
}

struct HomeWidgetData: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let value: String
    let imageName: String
    let accent: Color
    let action: () -> Void
}

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var discoveredElements: Int = 0
    @Published var discoveredReactions: Int = 0
    @Published var totalPoints: Int = 0
    @Published var totalElements: Int = 0
    @Published var totalExperiments: Int = 0
    @Published var successfulReactions: Int = 0
    @Published var totalReactions: Int = 0
    @Published var recentExperiments: [RecentExperimentItem] = []
    @Published var featuredElements: [Element] = []

    let coordinator: AppCoordinator
    private let storageService: StorageServiceProtocol
    private let elementService: ElementService
    private let reactionEngine: ReactionEngine

    var completionPercentage: Double {
        guard totalElements > 0 else { return 0 }
        return Double(discoveredElements) / Double(totalElements) * 100
    }

    var hiddenElements: Int { max(totalElements - discoveredElements, 0) }
    var lockedReactions: Int { max(totalReactions - discoveredReactions, 0) }

    var successRate: Double {
        guard totalExperiments > 0 else { return 0 }
        return Double(successfulReactions) / Double(totalExperiments) * 100
    }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.storageService = coordinator.storageService
        self.elementService = coordinator.elementService
        self.reactionEngine = coordinator.reactionEngine
        loadStats()
    }

    func loadStats() {
        let elements = elementService.getElements()
        totalElements = elements.count
        discoveredElements = elements.filter(\.isDiscovered).count
        featuredElements = Array(elements.filter(\.isDiscovered).prefix(4))

        let reactions = reactionEngine.getReactions()
        totalReactions = reactions.count
        discoveredReactions = reactionEngine.getDiscoveredReactions().count

        let inventory: Inventory = storageService.loadObject(forKey: StorageKeys.inventory) ?? Inventory()
        totalPoints = inventory.totalPoints
        totalExperiments = inventory.totalExperiments
        successfulReactions = inventory.successfulReactions

        let experiments: [Experiment] = storageService.load(forKey: StorageKeys.experiments)
        recentExperiments = experiments
            .sorted { $0.date > $1.date }
            .prefix(5)
            .map { exp in
                RecentExperimentItem(
                    id: exp.id,
                    emoji1: elementService.getElement(by: exp.element1Id)?.emoji ?? "?",
                    emoji2: elementService.getElement(by: exp.element2Id)?.emoji ?? "?",
                    resultEmoji: exp.resultElementId.flatMap { elementService.getElement(by: $0)?.emoji },
                    success: exp.success,
                    points: exp.pointsEarned,
                    date: exp.date
                )
            }
    }

    func goToLab() { coordinator.navigateToLab() }
    func goToElementList() { coordinator.navigateToElementList() }
    func goToReactionBook() { coordinator.navigateToReactionBook() }
    func goToStatistics() { coordinator.navigateToStatistics() }
    func goToSettings() { coordinator.navigateToSettings() }
}
