import SwiftUI
import Combine

enum AppRoute: Hashable {
    case lab
    case elementList
    case elementForm(elementId: UUID?)
    case reactionBook
    case statistics
    case settings
}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []

    let storageService: StorageServiceProtocol
    let elementService: ElementService
    let reactionEngine: ReactionEngine

    init() {
        self.storageService = UserDefaultsStorageService()
        self.elementService = ElementService(storageService: storageService)
        self.reactionEngine = ReactionEngine(
            storageService: storageService,
            elementService: elementService
        )
        bootstrapDataIfNeeded()
    }

    private func bootstrapDataIfNeeded() {
        _ = elementService.getElements()

        let reactions = reactionEngine.getReactions()
        if reactions.isEmpty {
            reactionEngine.getDefaultReactions().forEach { reactionEngine.addReaction($0) }
        }
    }

    func navigateToLab() {
        path.append(.lab)
    }

    func navigateToElementList() {
        path.append(.elementList)
    }

    func navigateToElementForm(element: Element? = nil) {
        path.append(.elementForm(elementId: element?.id))
    }

    func navigateToReactionBook() {
        path.append(.reactionBook)
    }

    func navigateToStatistics() {
        path.append(.statistics)
    }

    func navigateToSettings() {
        path.append(.settings)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    @ViewBuilder
    func destination(for route: AppRoute) -> some View {
        switch route {
        case .lab:
            LabView(viewModel: LabViewModel(
                elementService: elementService,
                reactionEngine: reactionEngine,
                storageService: storageService,
                coordinator: self
            ))

        case .elementList:
            ElementListView(viewModel: ElementListViewModel(
                elementService: elementService,
                coordinator: self
            ))

        case .elementForm(let elementId):
            let element = elementId.flatMap { elementService.getElement(by: $0) }
            ElementFormView(viewModel: ElementFormViewModel(
                element: element,
                elementService: elementService,
                coordinator: self
            ))

        case .reactionBook:
            ReactionBookView(viewModel: ReactionBookViewModel(
                reactionEngine: reactionEngine,
                elementService: elementService,
                coordinator: self
            ))

        case .statistics:
            StatisticsView(viewModel: StatisticsViewModel(
                storageService: storageService,
                elementService: elementService,
                reactionEngine: reactionEngine,
                coordinator: self
            ))

        case .settings:
            SettingsView(viewModel: SettingsViewModel(
                storageService: storageService,
                elementService: elementService,
                reactionEngine: reactionEngine,
                coordinator: self
            ))
        }
    }
}
