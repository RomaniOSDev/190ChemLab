import SwiftUI
import Combine

@MainActor
final class ElementFormViewModel: ObservableObject {
    @Published var name = ""
    @Published var symbol = ""
    @Published var selectedCategory: ElementCategory = .metal
    @Published var color = "#06dbab"
    @Published var properties = ""
    @Published var emoji = "🧪"

    private let elementService: ElementService
    private let coordinator: AppCoordinator
    private let editingElement: Element?

    var isEditing: Bool { editingElement != nil }

    var screenTitle: String { isEditing ? "Edit Element" : "Add Element" }

    let presetEmojis = ["🧪", "⚗️", "🔥", "💧", "⚙️", "🪙", "💨", "🧂", "🍬", "⚫", "🔵", "🌿", "⚠️", "💎", "🏆"]

    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !symbol.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(
        element: Element? = nil,
        elementService: ElementService,
        coordinator: AppCoordinator
    ) {
        self.editingElement = element
        self.elementService = elementService
        self.coordinator = coordinator

        if let element {
            name = element.name
            symbol = element.symbol
            selectedCategory = element.category
            color = element.color
            properties = element.properties
            emoji = element.emoji
        }
    }

    func saveElement() {
        guard isFormValid else { return }

        if isEditing, let element = editingElement {
            var updated = element
            updated.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updated.symbol = symbol.trimmingCharacters(in: .whitespacesAndNewlines)
            updated.category = selectedCategory
            updated.color = color
            updated.properties = properties
            updated.emoji = emoji
            elementService.updateElement(updated)
        } else {
            let newElement = Element(
                id: UUID(),
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                symbol: symbol.trimmingCharacters(in: .whitespacesAndNewlines),
                category: selectedCategory,
                color: color,
                properties: properties,
                isDiscovered: false,
                emoji: emoji,
                createdAt: Date()
            )
            elementService.addElement(newElement)
        }

        coordinator.pop()
    }

    func cancel() {
        coordinator.pop()
    }
}
