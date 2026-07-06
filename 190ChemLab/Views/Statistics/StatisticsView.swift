import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var viewModel: StatisticsViewModel

    init(viewModel: StatisticsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    heroStats
                    progressSection
                    chartSection
                    statsGrid
                    inventorySection
                    if !viewModel.recentExperimentItems.isEmpty {
                        recentSection
                    }
                }
                .padding(16)
                .readableContentWidth()
                .padding(.bottom, 32)
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
                Text("Statistics")
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)
            }
        }
        .onAppear { viewModel.loadStats() }
    }

    private var heroStats: some View {
        GlassCard(accent: AppColors.accent) {
            HStack(spacing: 20) {
                ProgressRingView(progress: viewModel.completionPercentage, size: 80)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Overall Progress")
                        .font(.headline)
                        .foregroundColor(AppColors.textPrimary)
                    Text("\(viewModel.discoveredElements) of \(viewModel.totalElements) elements")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    HStack(spacing: 12) {
                        miniStat(value: "\(viewModel.inventory.totalPoints)", label: "Points")
                        miniStat(value: String(format: "%.0f%%", viewModel.successRate), label: "Success")
                    }
                }
                Spacer()
            }
            .padding(20)
        }
    }

    private func miniStat(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(AppColors.accent)
            Text(label)
                .font(.caption2)
                .foregroundColor(AppColors.textSecondary)
        }
    }

    private var progressSection: some View {
        VStack(spacing: 12) {
            SectionHeaderView(title: "Discovery", subtitle: "Elements & reactions found")

            HStack(spacing: 10) {
                progressBar(
                    title: "Elements",
                    current: viewModel.discoveredElements,
                    total: viewModel.totalElements,
                    color: AppColors.accent
                )
                progressBar(
                    title: "Reactions",
                    current: viewModel.discoveredReactions,
                    total: max(viewModel.discoveredReactions + 3, 1),
                    color: AppColors.accentWarning
                )
            }
        }
    }

    private func progressBar(title: String, current: Int, total: Int, color: Color) -> some View {
        let progress = total > 0 ? Double(current) / Double(total) : 0
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title).font(.caption).foregroundColor(AppColors.textSecondary)
                Spacer()
                Text("\(current)/\(total)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            Capsule()
                .fill(AppColors.cardBackground)
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(color)
                        .scaleEffect(x: progress, y: 1, anchor: .leading)
                }
                .frame(height: 8)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.6))
        )
    }

    private var chartSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeaderView(title: "Overview", subtitle: "Your achievements")

                Chart(viewModel.chartData, id: \.label) { item in
                    BarMark(
                        x: .value("Category", item.label),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.accent, AppColors.accent.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(8)
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(AppColors.textSecondary.opacity(0.2))
                        AxisValueLabel()
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                .frame(height: 160)
            }
            .padding(16)
        }
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            StatTileView(icon: "", value: "\(viewModel.inventory.totalExperiments)", label: "Experiments", systemIcon: "flask.fill")
            StatTileView(icon: "", value: "\(viewModel.inventory.successfulReactions)", label: "Successful", accent: AppColors.accent, systemIcon: "checkmark.circle.fill")
            StatTileView(icon: "", value: "\(viewModel.inventory.totalExperiments - viewModel.inventory.successfulReactions)", label: "Failed", accent: AppColors.danger, systemIcon: "xmark.circle.fill")
            StatTileView(icon: "", value: "\(viewModel.discoveredReactions)", label: "Reactions Found", accent: AppColors.accentWarning, systemIcon: "book.fill")
        }
    }

    private var inventorySection: some View {
        GlassCard(accent: AppColors.accentWarning) {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeaderView(title: "Inventory", subtitle: "Collected from reactions")

                if viewModel.inventoryItems.isEmpty {
                    Text("No items yet. Complete reactions to collect elements.")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                } else {
                    ForEach(viewModel.inventoryItems, id: \.name) { item in
                        HStack(spacing: 12) {
                            Text(item.emoji).font(.title3)
                            Text(item.name)
                                .font(.subheadline)
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                            Text("×\(item.count)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.accent)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(AppColors.accent.opacity(0.12)))
                        }
                        if item.name != viewModel.inventoryItems.last?.name {
                            Divider().background(AppColors.textSecondary.opacity(0.15))
                        }
                    }
                }
            }
            .padding(16)
        }
    }

    private var recentSection: some View {
        VStack(spacing: 12) {
            SectionHeaderView(
                title: "Experiment History",
                subtitle: "Recent activity",
                count: viewModel.recentExperimentItems.count
            )

            GlassCard {
                VStack(spacing: 8) {
                    ForEach(viewModel.recentExperimentItems) { item in
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
    }
}
