import SwiftUI

struct RecentExperimentRow: View {
    let emoji1: String
    let emoji2: String
    let resultEmoji: String?
    let success: Bool
    let points: Int
    let date: Date

    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 4) {
                Text(emoji1).font(.title3)
                Text("+").font(.caption).foregroundColor(AppColors.textSecondary)
                Text(emoji2).font(.title3)
                Image(systemName: "arrow.right")
                    .font(.caption2)
                    .foregroundColor(AppColors.textSecondary)
                Text(resultEmoji ?? "💥").font(.title3)
            }
            .layoutPriority(1)

            Spacer(minLength: 4)

            VStack(alignment: .trailing, spacing: 2) {
                if success {
                    Text("+\(points) pts")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.accent)
                } else {
                    Text("Failed")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.danger)
                }
                Text(date, style: .relative)
                    .font(.caption2)
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(1)
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.7))
        )
    }
}
