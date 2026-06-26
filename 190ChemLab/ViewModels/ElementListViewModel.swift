import SwiftUI
import Combine

enum ElementSortOption: String, CaseIterable {
    case name = "Name"
    case category = "Category"
    case discovered = "Status"
}

@MainActor
final class ElementListViewModel: ObservableObject {
    @Published var elements: [Element] = []
    @Published var searchText = ""
    @Published var selectedCategory: ElementCategory?
    @Published var showDiscoveredOnly = false
    @Published var sortOption: ElementSortOption = .name
    @Published var selectedElement: Element?
    @Published var showDetail = false
    @Published var isGridLayout = false

    private let elementService: ElementService
    private let coordinator: AppCoordinator

    var discoveredCount: Int { elements.filter(\.isDiscovered).count }
    var hiddenCount: Int { elements.filter { !$0.isDiscovered }.count }

    var filteredElements: [Element] {
        var result = elements

        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        if showDiscoveredOnly {
            result = result.filter(\.isDiscovered)
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.symbol.localizedCaseInsensitiveContains(searchText)
            }
        }

        switch sortOption {
        case .name:
            result.sort { $0.name < $1.name }
        case .category:
            result.sort { $0.category.rawValue < $1.category.rawValue }
        case .discovered:
            result.sort { ($0.isDiscovered ? 0 : 1, $0.name) < ($1.isDiscovered ? 0 : 1, $1.name) }
        }

        return result
    }

    init(elementService: ElementService, coordinator: AppCoordinator) {
        self.elementService = elementService
        self.coordinator = coordinator
        loadElements()
    }

    func loadElements() {
        elements = elementService.getElements()
    }

    func showElementDetail(_ element: Element) {
        selectedElement = element
        showDetail = true
    }

    func deleteElement(_ element: Element) {
        guard !element.isDiscovered else { return }
        elementService.deleteElement(element)
        loadElements()
    }

    func goToElementForm(element: Element? = nil) {
        coordinator.navigateToElementForm(element: element)
    }

    func goBack() {
        coordinator.pop()
    }
}
