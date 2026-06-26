import SwiftUI

struct ReactionBookView: View {
    @StateObject private var viewModel: ReactionBookViewModel

    init(viewModel: ReactionBookViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 0) {
                summaryHeader
                filterTabs

                if viewModel.filteredReactions.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "📖",
                        title: "No Reactions",
                        message: "Start mixing elements in the laboratory to discover reactions",
                        actionTitle: "Go to Lab",
                        action: { viewModel.goBack() }
                    )
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredReactions) { reaction in
                                ReactionCardView(
                                    reaction: reaction,
                                    isLocked: !reaction.isDiscovered,
                                    element1: viewModel.getElement(by: reaction.element1Id),
                                    element2: viewModel.getElement(by: reaction.element2Id),
                                    resultElement: reaction.isDiscovered
                                        ? viewModel.getElement(by: reaction.resultElementId)
                                        : nil,
                                    onTap: { viewModel.showDetail(for: reaction) }
                                )
                            }
                        }
                        .padding(16)
                    }
                }
            }
        }
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
                Text("Reaction Book")
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)
            }
        }
        .sheet(isPresented: $viewModel.showDetail) {
            if let reaction = viewModel.selectedReaction {
                ReactionDetailSheet(
                    reaction: reaction,
                    element1: viewModel.getElement(by: reaction.element1Id),
                    element2: viewModel.getElement(by: reaction.element2Id),
                    resultElement: viewModel.getElement(by: reaction.resultElementId)
                )
            }
        }
        .onAppear { viewModel.loadReactions() }
    }

    private var summaryHeader: some View {
        HStack(spacing: 10) {
            StatTileView(
                icon: "✓",
                value: "\(viewModel.discoveredReactions.count)",
                label: "Discovered",
                accent: AppColors.accent
            )
            StatTileView(
                icon: "🔒",
                value: "\(viewModel.undiscoveredReactions.count)",
                label: "Locked",
                accent: AppColors.textSecondary
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var filterTabs: some View {
        HStack(spacing: 8) {
            ForEach(ReactionFilter.allCases, id: \.self) { filter in
                FilterChipView(
                    filter.rawValue,
                    isSelected: viewModel.filter == filter,
                    accent: AppColors.accentWarning
                ) {
                    viewModel.filter = filter
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }
}
