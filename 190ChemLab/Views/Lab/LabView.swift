import SwiftUI

struct LabView: View {
    @StateObject private var viewModel: LabViewModel

    init(viewModel: LabViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            if viewModel.showAnimation {
                ReactionAnimationView(
                    element1: viewModel.element1,
                    element2: viewModel.element2
                )
            }

            UIKitScrollView {
                VStack(spacing: 0) {
                    labHeader
                    reactionArea
                    mixButton
                    filterBar
                    elementGrid
                }
                .readableContentWidth()
                .padding(.bottom, 48)
                .frame(maxWidth: .infinity, alignment: .top)
            }
            .opacity(viewModel.showAnimation ? 0.25 : 1)
            .allowsHitTesting(!viewModel.showAnimation)
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
                Text("Laboratory")
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)
            }
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.selectedCount > 0 {
                    Button("Clear") { viewModel.clearAll() }
                        .font(.subheadline)
                        .foregroundColor(AppColors.danger)
                }
            }
        }
        .sheet(isPresented: $viewModel.showResult) {
            if let result = viewModel.reactionResult {
                ReactionResultSheet(result: result, onDismiss: viewModel.dismissResult)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var labHeader: some View {
        HStack(spacing: 12) {
            headerPill(icon: "star.fill", value: "\(viewModel.points)", label: "Points", color: AppColors.accent)
            headerPill(icon: "flask.fill", value: "\(viewModel.inventory.totalExperiments)", label: "Runs", color: AppColors.textSecondary)
            headerPill(icon: "checkmark.circle.fill", value: "\(viewModel.inventory.successfulReactions)", label: "Success", color: AppColors.accentWarning)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func headerPill(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon).font(.caption2).foregroundColor(color)
                Text(value).font(.subheadline).fontWeight(.bold).foregroundColor(AppColors.textPrimary)
            }
            Text(label).font(.system(size: 9)).foregroundColor(AppColors.textSecondary)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppColors.cardBackground)
        )
    }

    private var reactionArea: some View {
        GlassCard(accent: AppColors.accent) {
            HStack(spacing: 16) {
                ElementSlotView(
                    element: viewModel.element1,
                    slotLabel: "Element A",
                    onTap: { viewModel.clearSlot(1) }
                )

                VStack(spacing: 4) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(AppColors.textSecondary)
                    Image(systemName: "arrow.down")
                        .font(.caption)
                        .foregroundColor(AppColors.accent.opacity(0.5))
                }

                ElementSlotView(
                    element: viewModel.element2,
                    slotLabel: "Element B",
                    accent: AppColors.accentWarning,
                    onTap: { viewModel.clearSlot(2) }
                )
            }
            .padding(20)
        }
        .padding(.horizontal, 16)
    }

    private var mixButton: some View {
        AnimatedButton(
            title: viewModel.isProcessing ? "Mixing..." : "Mix Elements",
            icon: viewModel.isProcessing ? nil : "bolt.fill",
            color: viewModel.isMixEnabled ? AppColors.accent : Color.gray.opacity(0.35)
        ) {
            viewModel.mix()
        }
        .disabled(!viewModel.isMixEnabled)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var filterBar: some View {
        VStack(spacing: 10) {
            SearchBarView(text: $viewModel.searchText, placeholder: "Search elements...")
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChipView("All", isSelected: viewModel.selectedCategory == nil) {
                        viewModel.selectedCategory = nil
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
        }
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private var elementGrid: some View {
        if viewModel.filteredElements.isEmpty {
            EmptyStateView(
                icon: "🔍",
                title: "No Elements",
                message: "Try a different search or category filter"
            )
            .padding(.top, 40)
            .padding(.horizontal, 16)
        } else {
            LazyVGrid(
                columns: gridColumns,
                spacing: 10
            ) {
                ForEach(viewModel.filteredElements) { element in
                    LabElementCell(
                        element: element,
                        slotNumber: slotNumber(for: element.id),
                        onTap: { viewModel.selectElementAuto(element.id) }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var gridColumns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 140), spacing: 10)]
    }

    private func slotNumber(for id: UUID) -> Int? {
        if viewModel.slot1 == id { return 1 }
        if viewModel.slot2 == id { return 2 }
        return nil
    }
}

struct ReactionResultSheet: View {
    let result: ReactionResult
    let onDismiss: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            switch result {
            case .failure:
                resultIcon("❌", color: AppColors.danger)
                Text("Reaction Failed")
                    .font(.title2).fontWeight(.bold)
                    .foregroundColor(AppColors.textPrimary)
                Text("These elements do not react with each other.\nTry a different combination.")
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)

            case .success(let reaction, let e1, let e2, let result):
                resultIcon("⚗️", color: AppColors.accent)
                Text("Reaction Successful!")
                    .font(.title2).fontWeight(.bold)
                    .foregroundColor(AppColors.accent)
                reactionFormula(e1: e1, e2: e2, result: result)
                BadgeView(text: "+\(reaction.difficulty.points) points", color: AppColors.accent)

            case .newDiscovery(let reaction, let e1, let e2, let result):
                resultIcon("🎉", color: AppColors.accentWarning)
                Text("New Discovery!")
                    .font(.title2).fontWeight(.bold)
                    .foregroundColor(AppColors.accentWarning)
                reactionFormula(e1: e1, e2: e2, result: result)
                BadgeView(text: "New element unlocked! +\(reaction.difficulty.points) pts", color: AppColors.accentWarning)
            }

            AnimatedButton(title: "Continue", icon: "arrow.right", color: AppColors.accent) {
                dismiss()
                onDismiss()
            }
            .padding(.horizontal)
        }
        .padding(24)
        .background(AppColors.background)
    }

    private func resultIcon(_ emoji: String, color: Color) -> some View {
        Text(emoji)
            .font(.system(size: 56))
            .padding(16)
            .background(Circle().fill(color.opacity(0.12)))
    }

    private func reactionFormula(e1: Element?, e2: Element?, result: Element?) -> some View {
        HStack(spacing: 12) {
            formulaItem(e1)
            Text("+").foregroundColor(AppColors.textSecondary)
            formulaItem(e2)
            Image(systemName: "arrow.right")
                .foregroundColor(AppColors.accent)
            formulaItem(result, highlight: true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.cardBackground)
        )
    }

    private func formulaItem(_ element: Element?, highlight: Bool = false) -> some View {
        VStack(spacing: 4) {
            Text(element?.emoji ?? "?").font(.title)
            Text(element?.symbol ?? "?")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(highlight ? AppColors.accent : AppColors.textPrimary)
        }
    }
}
