import SwiftUI

struct ElementListView: View {
    @StateObject private var viewModel: ElementListViewModel

    init(viewModel: ElementListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            UIKitScrollView {
                VStack(spacing: 0) {
                    summaryBar
                    SearchBarView(text: $viewModel.searchText, placeholder: "Search by name or symbol...")
                        .padding(.horizontal, 16)
                        .padding(.bottom, 10)

                    filterBar
                    sortBar
                    elementContent
                }
                .readableContentWidth()
                .padding(.bottom, 48)
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(AppColors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: viewModel.goBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(AppColors.accent)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("All Elements")
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    Button {
                        viewModel.isGridLayout.toggle()
                    } label: {
                        Image(systemName: viewModel.isGridLayout ? "list.bullet" : "square.grid.2x2")
                            .foregroundColor(AppColors.accent)
                    }
                    Button(action: { viewModel.goToElementForm() }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppColors.accent)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showDetail) {
            if let element = viewModel.selectedElement {
                ElementDetailSheet(
                    element: element,
                    onEdit: element.isDiscovered ? nil : { viewModel.goToElementForm(element: element) },
                    onDelete: element.isDiscovered ? nil : { viewModel.deleteElement(element) }
                )
            }
        }
        .onAppear { viewModel.loadElements() }
    }

    @ViewBuilder
    private var elementContent: some View {
        if viewModel.filteredElements.isEmpty {
            EmptyStateView(
                icon: "🔍",
                title: "No Elements Found",
                message: "Try adjusting your search or filters",
                actionTitle: "Add Element",
                action: { viewModel.goToElementForm() }
            )
            .padding(.top, 40)
            .padding(.horizontal, 16)
        } else if viewModel.isGridLayout {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 12)],
                spacing: 12
            ) {
                ForEach(viewModel.filteredElements) { element in
                    ElementGridCardView(element: element) {
                        viewModel.showElementDetail(element)
                    }
                }
            }
            .padding(16)
        } else {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredElements) { element in
                    ElementCardView(
                        element: element,
                        onTap: { viewModel.showElementDetail(element) },
                        onEdit: element.isDiscovered ? nil : { viewModel.goToElementForm(element: element) },
                        onDelete: element.isDiscovered ? nil : { viewModel.deleteElement(element) }
                    )
                }
            }
            .padding(16)
        }
    }

    private var summaryBar: some View {
        HStack(spacing: 10) {
            summaryPill(value: "\(viewModel.discoveredCount)", label: "Discovered", color: AppColors.accent)
            summaryPill(value: "\(viewModel.hiddenCount)", label: "Hidden", color: AppColors.textSecondary)
            summaryPill(value: "\(viewModel.filteredElements.count)", label: "Showing", color: AppColors.accentWarning)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func summaryPill(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppColors.cardBackground)
        )
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChipView("All", isSelected: viewModel.selectedCategory == nil && !viewModel.showDiscoveredOnly) {
                    viewModel.selectedCategory = nil
                    viewModel.showDiscoveredOnly = false
                }
                FilterChipView("Discovered", icon: "✓", isSelected: viewModel.showDiscoveredOnly) {
                    viewModel.showDiscoveredOnly.toggle()
                }
                ForEach(ElementCategory.allCases, id: \.self) { category in
                    FilterChipView(
                        category.rawValue,
                        icon: category.icon,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        viewModel.selectedCategory = viewModel.selectedCategory == category ? nil : category
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 8)
    }

    private var sortBar: some View {
        HStack {
            Text("Sort by")
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
            Picker("Sort", selection: $viewModel.sortOption) {
                ForEach(ElementSortOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }
}
