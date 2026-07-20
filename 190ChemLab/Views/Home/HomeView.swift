import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        ScreenScrollContainer {
            VStack(spacing: 16) {
                HomeHeroBanner(
                    greeting: viewModel.greeting,
                    completion: viewModel.completionPercentage,
                    experiments: viewModel.totalExperiments,
                    onTapLab: viewModel.goToLab
                )

                statsWidgetsRow
                labWidget
                widgetGrid

                HomeFeaturedElementsWidget(
                    elements: viewModel.featuredElements,
                    hiddenCount: viewModel.hiddenElements,
                    onTap: viewModel.goToElementList
                )

                HomeDailyGoalWidget(
                    completion: viewModel.completionPercentage,
                    points: viewModel.totalPoints,
                    successRate: viewModel.successRate
                )

                if !viewModel.recentExperiments.isEmpty {
                    recentActivitySection
                }

                bottomActions
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.loadStats() }
    }

    private var statsWidgetsRow: some View {
        HStack(spacing: 10) {
            HomeCompactWidget(
                icon: "atom",
                title: "Elements",
                value: "\(viewModel.discoveredElements)/\(viewModel.totalElements)",
                subtitle: "\(viewModel.hiddenElements) hidden",
                accent: AppColors.accent,
                action: viewModel.goToElementList
            )
            .homeRowWidth()

            HomeCompactWidget(
                icon: "book.fill",
                title: "Reactions",
                value: "\(viewModel.discoveredReactions)",
                subtitle: "\(viewModel.lockedReactions) locked",
                accent: AppColors.accentWarning,
                action: viewModel.goToReactionBook
            )
            .homeRowWidth()
        }
    }

    private var labWidget: some View {
        HomeImageWidget(
            title: "Laboratory",
            subtitle: "Mix two elements and discover new reactions",
            value: "⚡ Open Lab",
            badge: "FEATURED",
            imageName: "HomeHero",
            accent: AppColors.accent,
            height: 170,
            action: viewModel.goToLab
        )
        .homeRowWidth()
    }

    private var widgetGrid: some View {
        HStack(alignment: .top, spacing: 10) {
            HomeImageWidget(
                title: "Elements",
                subtitle: "Browse catalog",
                value: "\(viewModel.discoveredElements) found",
                badge: nil,
                imageName: "WidgetElements",
                accent: AppColors.danger,
                height: 170,
                action: viewModel.goToElementList
            )
            .homeRowWidth()

            HomeImageWidget(
                title: "Reactions",
                subtitle: "Reaction book",
                value: "\(viewModel.lockedReactions) to unlock",
                badge: nil,
                imageName: "WidgetReactions",
                accent: AppColors.accentWarning,
                height: 170,
                action: viewModel.goToReactionBook
            )
            .homeRowWidth()
        }
    }

    private var recentActivitySection: some View {
        VStack(spacing: 12) {
            SectionHeaderView(
                title: "Recent Activity",
                subtitle: "Your latest experiments",
                count: viewModel.recentExperiments.count,
                accent: AppColors.accent
            )

            GlassCard {
                VStack(spacing: 8) {
                    ForEach(viewModel.recentExperiments) { item in
                        RecentExperimentRow(
                            emoji1: item.emoji1,
                            emoji2: item.emoji2,
                            resultEmoji: item.resultEmoji,
                            success: item.success,
                            points: item.points,
                            date: item.date
                        )
                    }
                }
                .padding(12)
            }
        }
        .homeRowWidth()
    }

    private var bottomActions: some View {
        HStack(spacing: 10) {
            bottomButton(
                imageName: "WidgetStats",
                title: "Statistics",
                subtitle: "\(viewModel.totalPoints) pts",
                accent: AppColors.accent,
                action: viewModel.goToStatistics
            )
            .homeRowWidth()

            bottomButton(
                imageName: nil,
                title: "Settings",
                subtitle: "Preferences",
                accent: AppColors.textSecondary,
                action: viewModel.goToSettings
            )
            .homeRowWidth()
        }
    }

    private func bottomButton(
        imageName: String?,
        title: String,
        subtitle: String,
        accent: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let imageName {
                    BoundedFillImage(name: imageName, height: 36, cornerRadius: 8)
                        .frame(width: 36, height: 36)
                } else {
                    Image(systemName: "gear")
                        .font(.body)
                        .foregroundColor(accent)
                        .frame(width: 36, height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(accent.opacity(0.12))
                        )
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(1)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(accent)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(accent.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(ScalePressButtonStyle())
    }
}
