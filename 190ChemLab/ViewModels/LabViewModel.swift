import SwiftUI
import Combine

@MainActor
final class LabViewModel: ObservableObject {
    @Published var slot1: UUID?
    @Published var slot2: UUID?
    @Published var reactionResult: ReactionResult?
    @Published var showResult = false
    @Published var isProcessing = false
    @Published var showAnimation = false
    @Published var inventory: Inventory
    @Published var points: Int = 0
    @Published var searchText = ""
    @Published var selectedCategory: ElementCategory?

    private let elementService: ElementService
    private let reactionEngine: ReactionEngine
    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator

    var allElements: [Element] {
        elementService.getElements().filter(\.isDiscovered)
    }

    var filteredElements: [Element] {
        var result = allElements

        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.symbol.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result
    }

    var element1: Element? {
        guard let id = slot1 else { return nil }
        return elementService.getElement(by: id)
    }

    var element2: Element? {
        guard let id = slot2 else { return nil }
        return elementService.getElement(by: id)
    }

    var isMixEnabled: Bool {
        slot1 != nil && slot2 != nil && !isProcessing && slot1 != slot2
    }

    var selectedCount: Int {
        [slot1, slot2].compactMap { $0 }.count
    }

    init(
        elementService: ElementService,
        reactionEngine: ReactionEngine,
        storageService: StorageServiceProtocol,
        coordinator: AppCoordinator
    ) {
        self.elementService = elementService
        self.reactionEngine = reactionEngine
        self.storageService = storageService
        self.coordinator = coordinator

        let loaded: Inventory = storageService.loadObject(forKey: StorageKeys.inventory) ?? Inventory()
        self.inventory = loaded
        self.points = loaded.totalPoints
    }

    func selectElement(for slot: Int, elementId: UUID) {
        if slot == 1 {
            slot1 = slot1 == elementId ? nil : elementId
            if slot2 == elementId { slot2 = nil }
        } else {
            slot2 = slot2 == elementId ? nil : elementId
            if slot1 == elementId { slot1 = nil }
        }
    }

    func selectElementAuto(_ elementId: UUID) {
        if slot1 == elementId {
            slot1 = nil
            return
        }
        if slot2 == elementId {
            slot2 = nil
            return
        }
        if slot1 == nil {
            slot1 = elementId
        } else if slot2 == nil {
            slot2 = elementId
        } else {
            slot2 = elementId
        }
    }

    func clearSlot(_ slot: Int) {
        if slot == 1 { slot1 = nil }
        else { slot2 = nil }
    }

    func clearAll() {
        slot1 = nil
        slot2 = nil
    }

    func mix() {
        guard isMixEnabled, let id1 = slot1, let id2 = slot2 else { return }
        isProcessing = true
        showAnimation = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            self.showAnimation = false

            let result = self.reactionEngine.performReaction(element1Id: id1, element2Id: id2)
            self.reactionResult = result
            self.showResult = true
            self.recordExperiment(result: result)
            self.isProcessing = false
        }
    }

    private func recordExperiment(result: ReactionResult) {
        switch result {
        case .success(let reaction, _, _, let resultElement):
            applySuccess(reaction: reaction, resultElement: resultElement)

        case .newDiscovery(let reaction, _, _, let resultElement):
            reactionEngine.discoverReaction(reaction)
            if var element = resultElement {
                element.isDiscovered = true
                elementService.updateElement(element)
            }
            applySuccess(reaction: reaction, resultElement: resultElement)

        case .failure:
            var updated = inventory
            updated.totalExperiments += 1
            inventory = updated
            storageService.saveObject(updated, forKey: StorageKeys.inventory)
            points = updated.totalPoints

            let experiment = Experiment(
                id: UUID(),
                element1Id: slot1!,
                element2Id: slot2!,
                resultElementId: nil,
                success: false,
                date: Date(),
                pointsEarned: 0
            )
            storageService.append(experiment, forKey: StorageKeys.experiments)
        }
    }

    private func applySuccess(reaction: Reaction, resultElement: Element?) {
        guard let resultElement else { return }

        if !resultElement.isDiscovered {
            var unlocked = resultElement
            unlocked.isDiscovered = true
            elementService.updateElement(unlocked)
        }

        var updated = inventory
        updated.totalExperiments += 1
        updated.successfulReactions += 1
        updated.totalPoints += reaction.difficulty.points
        let count = updated.elements[resultElement.id] ?? 0
        updated.elements[resultElement.id] = count + 1
        inventory = updated
        storageService.saveObject(updated, forKey: StorageKeys.inventory)
        points = updated.totalPoints

        let experiment = Experiment(
            id: UUID(),
            element1Id: slot1!,
            element2Id: slot2!,
            resultElementId: resultElement.id,
            success: true,
            date: Date(),
            pointsEarned: reaction.difficulty.points
        )
        storageService.append(experiment, forKey: StorageKeys.experiments)
    }

    func dismissResult() {
        showResult = false
        slot1 = nil
        slot2 = nil
    }

    func goBack() {
        coordinator.pop()
    }
}
