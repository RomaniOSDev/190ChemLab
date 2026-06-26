import Foundation

final class ReactionEngine {
    private let storageService: StorageServiceProtocol
    private let elementService: ElementService

    init(
        storageService: StorageServiceProtocol = UserDefaultsStorageService(),
        elementService: ElementService = ElementService()
    ) {
        self.storageService = storageService
        self.elementService = elementService
    }

    func getReactions() -> [Reaction] {
        storageService.load(forKey: StorageKeys.reactions)
    }

    func getDefaultReactions() -> [Reaction] {
        let elements = elementService.getElements()

        func element(named name: String) -> Element? {
            elements.first { $0.name == name }
        }

        var reactions: [Reaction] = []

        if let iron = element(named: "Iron"),
           let oxygen = element(named: "Oxygen"),
           let rust = element(named: "Iron Oxide") {
            reactions.append(Reaction(
                id: UUID(),
                element1Id: iron.id,
                element2Id: oxygen.id,
                resultElementId: rust.id,
                description: "Iron + Oxygen = Iron Oxide (Fe₂O₃)",
                isDiscovered: true,
                discoveredAt: Date(),
                difficulty: .easy
            ))
        }

        if let hydrogen = element(named: "Hydrogen"),
           let oxygen = element(named: "Oxygen"),
           let water = element(named: "Water") {
            reactions.append(Reaction(
                id: UUID(),
                element1Id: hydrogen.id,
                element2Id: oxygen.id,
                resultElementId: water.id,
                description: "Hydrogen + Oxygen = Water (H₂O)",
                isDiscovered: true,
                discoveredAt: Date(),
                difficulty: .easy
            ))
        }

        if let carbon = element(named: "Carbon"),
           let oxygen = element(named: "Oxygen"),
           let co2 = element(named: "Carbon Dioxide") {
            reactions.append(Reaction(
                id: UUID(),
                element1Id: carbon.id,
                element2Id: oxygen.id,
                resultElementId: co2.id,
                description: "Carbon + Oxygen = Carbon Dioxide (CO₂)",
                isDiscovered: false,
                discoveredAt: nil,
                difficulty: .medium
            ))
        }

        if let copper = element(named: "Copper"),
           let oxygen = element(named: "Oxygen"),
           let cuo = element(named: "Copper Oxide") {
            reactions.append(Reaction(
                id: UUID(),
                element1Id: copper.id,
                element2Id: oxygen.id,
                resultElementId: cuo.id,
                description: "Copper + Oxygen = Copper Oxide (CuO)",
                isDiscovered: false,
                discoveredAt: nil,
                difficulty: .medium
            ))
        }

        if let hcl = element(named: "Hydrochloric Acid"),
           let naoh = element(named: "Sodium Hydroxide"),
           let salt = element(named: "Table Salt") {
            reactions.append(Reaction(
                id: UUID(),
                element1Id: hcl.id,
                element2Id: naoh.id,
                resultElementId: salt.id,
                description: "HCl + NaOH = NaCl + H₂O",
                isDiscovered: false,
                discoveredAt: nil,
                difficulty: .hard
            ))
        }

        return reactions
    }

    func performReaction(element1Id: UUID, element2Id: UUID) -> ReactionResult {
        let reactions = getReactions()

        guard let reaction = reactions.first(where: {
            ($0.element1Id == element1Id && $0.element2Id == element2Id) ||
            ($0.element1Id == element2Id && $0.element2Id == element1Id)
        }) else {
            return .failure
        }

        let element1 = elementService.getElement(by: element1Id)
        let element2 = elementService.getElement(by: element2Id)
        let result = elementService.getElement(by: reaction.resultElementId)

        if reaction.isDiscovered {
            return .success(reaction: reaction, element1: element1, element2: element2, result: result)
        } else {
            return .newDiscovery(reaction: reaction, element1: element1, element2: element2, result: result)
        }
    }

    func addReaction(_ reaction: Reaction) {
        storageService.append(reaction, forKey: StorageKeys.reactions)
    }

    func discoverReaction(_ reaction: Reaction) {
        var updated = reaction
        updated.isDiscovered = true
        updated.discoveredAt = Date()
        storageService.update(updated, forKey: StorageKeys.reactions)
    }

    func getDiscoveredReactions() -> [Reaction] {
        getReactions().filter(\.isDiscovered)
    }
}
