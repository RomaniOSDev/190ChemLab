import Foundation

final class ElementService {
    private let storageService: StorageServiceProtocol

    init(storageService: StorageServiceProtocol = UserDefaultsStorageService()) {
        self.storageService = storageService
    }

    func getElements() -> [Element] {
        var elements = storageService.load(forKey: StorageKeys.elements) as [Element]
        if elements.isEmpty {
            elements = getDefaultElements()
            storageService.save(elements, forKey: StorageKeys.elements)
        }
        return elements
    }

    func addElement(_ element: Element) {
        storageService.append(element, forKey: StorageKeys.elements)
    }

    func updateElement(_ element: Element) {
        storageService.update(element, forKey: StorageKeys.elements)
    }

    func deleteElement(_ element: Element) {
        var elements = getElements()
        elements.removeAll { $0.id == element.id }
        storageService.save(elements, forKey: StorageKeys.elements)
    }

    func getElement(by id: UUID) -> Element? {
        getElements().first { $0.id == id }
    }

    func getDefaultElements() -> [Element] {
        let now = Date()
        return [
            Element(id: UUID(), name: "Iron", symbol: "Fe", category: .metal, color: "#808080", properties: "Hard gray metal", isDiscovered: true, emoji: "⚙️", createdAt: now),
            Element(id: UUID(), name: "Copper", symbol: "Cu", category: .metal, color: "#B87333", properties: "Reddish-brown metal", isDiscovered: true, emoji: "🪙", createdAt: now),
            Element(id: UUID(), name: "Aluminum", symbol: "Al", category: .metal, color: "#C0C0C0", properties: "Light silvery metal", isDiscovered: true, emoji: "📀", createdAt: now),
            Element(id: UUID(), name: "Sodium", symbol: "Na", category: .metal, color: "#D3D3D3", properties: "Soft silvery metal", isDiscovered: true, emoji: "🧂", createdAt: now),

            Element(id: UUID(), name: "Carbon", symbol: "C", category: .nonMetal, color: "#2F2F2F", properties: "Solid element, basis of life", isDiscovered: true, emoji: "⚫", createdAt: now),
            Element(id: UUID(), name: "Silicon", symbol: "Si", category: .nonMetal, color: "#B0B0B0", properties: "Gray semiconductor", isDiscovered: true, emoji: "💻", createdAt: now),

            Element(id: UUID(), name: "Oxygen", symbol: "O₂", category: .gas, color: "#00BFFF", properties: "Colorless odorless gas", isDiscovered: true, emoji: "💨", createdAt: now),
            Element(id: UUID(), name: "Hydrogen", symbol: "H₂", category: .gas, color: "#E0E0E0", properties: "Light flammable gas", isDiscovered: true, emoji: "🔥", createdAt: now),
            Element(id: UUID(), name: "Nitrogen", symbol: "N₂", category: .gas, color: "#808080", properties: "Inert gas, 78% of air", isDiscovered: true, emoji: "🌬️", createdAt: now),

            Element(id: UUID(), name: "Water", symbol: "H₂O", category: .liquid, color: "#4169E1", properties: "Transparent liquid", isDiscovered: true, emoji: "💧", createdAt: now),
            Element(id: UUID(), name: "Hydrochloric Acid", symbol: "HCl", category: .acid, color: "#FFD700", properties: "Corrosive acid", isDiscovered: true, emoji: "🧪", createdAt: now),
            Element(id: UUID(), name: "Sulfuric Acid", symbol: "H₂SO₄", category: .acid, color: "#FF4500", properties: "Dangerous acid", isDiscovered: true, emoji: "⚠️", createdAt: now),

            Element(id: UUID(), name: "Table Salt", symbol: "NaCl", category: .salt, color: "#FFFFFF", properties: "White crystals", isDiscovered: true, emoji: "🧂", createdAt: now),
            Element(id: UUID(), name: "Copper Sulfate", symbol: "CuSO₄", category: .salt, color: "#1E90FF", properties: "Blue crystals", isDiscovered: true, emoji: "🔵", createdAt: now),

            Element(id: UUID(), name: "Sugar", symbol: "C₁₂H₂₂O₁₁", category: .organic, color: "#F5F5DC", properties: "Sweet substance", isDiscovered: true, emoji: "🍬", createdAt: now),
            Element(id: UUID(), name: "Ethanol", symbol: "C₂H₅OH", category: .organic, color: "#C0C0C0", properties: "Flammable liquid", isDiscovered: true, emoji: "🍷", createdAt: now),

            Element(id: UUID(), name: "Gold", symbol: "Au", category: .metal, color: "#FFD700", properties: "Noble yellow metal", isDiscovered: false, emoji: "🏆", createdAt: now),
            Element(id: UUID(), name: "Platinum", symbol: "Pt", category: .metal, color: "#E5E4E2", properties: "Noble silvery metal", isDiscovered: false, emoji: "💎", createdAt: now),
            Element(id: UUID(), name: "Mercury", symbol: "Hg", category: .liquid, color: "#C0C0C0", properties: "Liquid silvery metal", isDiscovered: false, emoji: "🌡️", createdAt: now),

            Element(id: UUID(), name: "Iron Oxide", symbol: "Fe₂O₃", category: .salt, color: "#8B4513", properties: "Rust, reddish-brown powder", isDiscovered: false, emoji: "🟤", createdAt: now),
            Element(id: UUID(), name: "Carbon Dioxide", symbol: "CO₂", category: .gas, color: "#A9A9A9", properties: "Colorless gas from respiration", isDiscovered: false, emoji: "🌫️", createdAt: now),
            Element(id: UUID(), name: "Copper Oxide", symbol: "CuO", category: .salt, color: "#000000", properties: "Black powder", isDiscovered: false, emoji: "⚫", createdAt: now),
            Element(id: UUID(), name: "Sodium Hydroxide", symbol: "NaOH", category: .base, color: "#F0F0F0", properties: "Strong base, caustic soda", isDiscovered: true, emoji: "🧴", createdAt: now)
        ]
    }
}

enum StorageKeys {
    static let elements = "elements"
    static let reactions = "reactions"
    static let inventory = "inventory"
    static let experiments = "experiments"
}
