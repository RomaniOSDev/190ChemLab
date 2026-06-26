import SwiftUI

struct StatTileView: View {
    let icon: String
    let value: String
    let label: String
    var accent: Color = AppColors.accent
    var systemIcon: String? = nil

    var body: some View {
        VStack(spacing: 8) {
            if let systemIcon {
                Image(systemName: systemIcon)
                    .font(.title3)
                    .foregroundColor(accent)
            } else {
                Text(icon).font(.title3)
            }

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.textPrimary)
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            Text(label)
                .font(.caption2)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(accent.opacity(0.2), lineWidth: 1)
                )
        )
    }
}
