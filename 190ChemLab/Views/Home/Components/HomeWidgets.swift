import SwiftUI

struct HomeHeroBanner: View {
    let greeting: String
    let completion: Double
    let experiments: Int
    let onTapLab: () -> Void

    var body: some View {
        Button(action: onTapLab) {
            ZStack(alignment: .bottomLeading) {
                BoundedFillImage(name: "HomeHero", height: 190, cornerRadius: 20)

                LinearGradient(
                    colors: [.clear, AppColors.background.opacity(0.35), AppColors.background.opacity(0.92)],
                    startPoint: .top,
                    endPoint: .bottom
                )

                HStack(alignment: .bottom, spacing: 8) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(greeting)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(AppColors.accent)

                        Text("Virtual Laboratory")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.textPrimary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.85)

                        VStack(alignment: .leading, spacing: 4) {
                            Label("\(experiments) runs", systemImage: "flask.fill")
                            Label(String(format: "%.0f%% done", completion), systemImage: "chart.pie.fill")
                        }
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 4) {
                        ProgressRingView(progress: completion, lineWidth: 6, size: 56, showGlow: false)
                        Text("Start Mix")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.accent)
                    }
                }
                .padding(14)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 190)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(AppColors.accent.opacity(0.35), lineWidth: 1)
            )
        }
        .buttonStyle(ScalePressButtonStyle())
    }
}

struct HomeImageWidget: View {
    let title: String
    let subtitle: String
    let value: String
    let badge: String?
    let imageName: String
    let accent: Color
    var height: CGFloat = 160
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                BoundedFillImage(name: imageName, height: height, cornerRadius: 16)

                LinearGradient(
                    colors: [.clear, accent.opacity(0.12), AppColors.background.opacity(0.95)],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 4) {
                    if let badge {
                        Text(badge)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(AppColors.background)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(accent))
                    }

                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)

                    Text(value)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(accent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(accent.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(ScalePressButtonStyle())
    }
}

struct HomeCompactWidget: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let accent: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .font(.body)
                        .foregroundColor(accent)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(accent.opacity(0.15)))
                    Spacer(minLength: 0)
                    Image(systemName: "arrow.up.right")
                        .font(.caption2)
                        .foregroundColor(accent.opacity(0.7))
                }

                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)

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
            .padding(10)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
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

struct HomeFeaturedElementsWidget: View {
    let elements: [Element]
    let hiddenCount: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            GlassCard(accent: AppColors.danger) {
                HStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Element Collection")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.textPrimary)
                            .lineLimit(1)

                        Text("\(hiddenCount) hidden elements to discover")
                            .font(.caption2)
                            .foregroundColor(AppColors.textSecondary)
                            .lineLimit(2)

                        HStack(spacing: 4) {
                            ForEach(elements.prefix(3)) { element in
                                Text(element.emoji)
                                    .font(.body)
                                    .frame(width: 28, height: 28)
                                    .background(Circle().fill(Color(hex: element.color).opacity(0.25)))
                            }
                            if hiddenCount > 0 {
                                Text("+\(hiddenCount)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColors.danger)
                                    .frame(width: 28, height: 28)
                                    .background(Circle().fill(AppColors.danger.opacity(0.15)))
                            }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                    BoundedFillImage(name: "WidgetElements", height: 56, cornerRadius: 10)
                        .frame(width: 56, height: 56)
                }
                .padding(12)
            }
        }
        .buttonStyle(ScalePressButtonStyle())
    }
}

struct HomeDailyGoalWidget: View {
    let completion: Double
    let points: Int
    let successRate: Double

    var body: some View {
        GlassCard(accent: AppColors.accentWarning) {
            HStack(alignment: .center, spacing: 10) {
                BoundedFillImage(name: "WidgetStats", height: 52, cornerRadius: 10)
                    .frame(width: 52, height: 52)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Today's Progress")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.textPrimary)

                    HStack(spacing: 0) {
                        goalItem(icon: "star.fill", value: "\(points)", label: "Points")
                        goalItem(icon: "percent", value: String(format: "%.0f%%", successRate), label: "Success")
                        goalItem(icon: "scope", value: String(format: "%.0f%%", completion), label: "Found")
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
        }
    }

    private func goalItem(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(AppColors.accentWarning)
            Text(value)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(label)
                .font(.system(size: 8))
                .foregroundColor(AppColors.textSecondary)
                .lineLimit(1)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}
