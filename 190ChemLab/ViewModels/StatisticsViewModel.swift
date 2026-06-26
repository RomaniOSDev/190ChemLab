import SwiftUI
import Combine

@MainActor
final class StatisticsViewModel: ObservableObject {
    @Published var inventory: Inventory
    @Published var discoveredElements: Int = 0
    @Published var discoveredReactions: Int = 0
    @Published var totalElements: Int = 0
    @Published var experiments: [Experiment] = []

    private let storageService: StorageServiceProtocol
    private let elementService: ElementService
    private let reactionEngine: ReactionEngine
    private let coordinator: AppCoordinator

    var completionPercentage: Double {
        guard totalElements > 0 else { return 0 }
        return Double(discoveredElements) / Double(totalElements) * 100
    }

    var successRate: Double {
        guard inventory.totalExperiments > 0 else { return 0 }
        return Double(inventory.successfulReactions) / Double(inventory.totalExperiments) * 100
    }

    var chartData: [(label: String, value: Double)] {
        [
            ("Elements", Double(discoveredElements)),
            ("Reactions", Double(discoveredReactions)),
            ("Points", Double(inventory.totalPoints) / 10)
        ]
    }

    var inventoryItems: [(name: String, emoji: String, count: Int, color: String)] {
        inventory.elements.compactMap { elementId, count in
            guard let element = elementService.getElement(by: elementId) else { return nil }
            return (element.name, element.emoji, count, element.color)
        }.sorted { $0.name < $1.name }
    }

    var recentExperimentItems: [RecentExperimentItem] {
        experiments
            .sorted { $0.date > $1.date }
            .prefix(10)
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

    init(
        storageService: StorageServiceProtocol,
        elementService: ElementService,
        reactionEngine: ReactionEngine,
        coordinator: AppCoordinator
    ) {
        self.storageService = storageService
        self.elementService = elementService
        self.reactionEngine = reactionEngine
        self.coordinator = coordinator
        self.inventory = storageService.loadObject(forKey: StorageKeys.inventory) ?? Inventory()
        loadStats()
    }

    func loadStats() {
        inventory = storageService.loadObject(forKey: StorageKeys.inventory) ?? Inventory()
        experiments = storageService.load(forKey: StorageKeys.experiments)

        let elements = elementService.getElements()
        totalElements = elements.count
        discoveredElements = elements.filter(\.isDiscovered).count
        discoveredReactions = reactionEngine.getDiscoveredReactions().count
    }

    func goBack() {
        coordinator.pop()
    }
}
