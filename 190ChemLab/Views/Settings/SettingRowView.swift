import SwiftUI

struct SettingRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    var iconColor: Color = AppColors.accent
    var titleColor: Color = AppColors.textPrimary
    var showChevron: Bool = false
    var trailing: String? = nil

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.body)
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(titleColor)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }

            Spacer()

            if let trailing {
                Text(trailing)
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }

            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
