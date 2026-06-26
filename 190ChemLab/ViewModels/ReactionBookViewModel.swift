import SwiftUI
import Combine

enum ReactionFilter: String, CaseIterable {
    case all = "All"
    case discovered = "Discovered"
    case locked = "Locked"
}

@MainActor
final class ReactionBookViewModel: ObservableObject {
    @Published var reactions: [Reaction] = []
    @Published var filter: ReactionFilter = .all
    @Published var selectedReaction: Reaction?
    @Published var showDetail = false

    private let reactionEngine: ReactionEngine
    private let elementService: ElementService
    private let coordinator: AppCoordinator

    var discoveredReactions: [Reaction] {
        reactions.filter(\.isDiscovered)
    }

    var undiscoveredReactions: [Reaction] {
        reactions.filter { !$0.isDiscovered }
    }

    var filteredReactions: [Reaction] {
        switch filter {
        case .all: return reactions
        case .discovered: return discoveredReactions
        case .locked: return undiscoveredReactions
        }
    }

    init(
        reactionEngine: ReactionEngine,
        elementService: ElementService,
        coordinator: AppCoordinator
    ) {
        self.reactionEngine = reactionEngine
        self.elementService = elementService
        self.coordinator = coordinator
        loadReactions()
    }

    func loadReactions() {
        reactions = reactionEngine.getReactions()
    }

    func showDetail(for reaction: Reaction) {
        selectedReaction = reaction
        showDetail = true
    }

    func getElementName(by id: UUID) -> String {
        elementService.getElement(by: id)?.name ?? "Unknown"
    }

    func getElementEmoji(by id: UUID) -> String {
        elementService.getElement(by: id)?.emoji ?? "🧪"
    }

    func getElementSymbol(by id: UUID) -> String {
        elementService.getElement(by: id)?.symbol ?? "?"
    }

    func getElement(by id: UUID) -> Element? {
        elementService.getElement(by: id)
    }

    func goBack() {
        coordinator.pop()
    }
}
