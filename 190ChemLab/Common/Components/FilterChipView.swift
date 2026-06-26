import SwiftUI

struct FilterChipView: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    let accent: Color
    let action: () -> Void

    init(
        _ title: String,
        icon: String? = nil,
        isSelected: Bool,
        accent: Color = AppColors.accent,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.accent = accent
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon {
                    Text(icon).font(.caption2)
                }
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .foregroundColor(isSelected ? AppColors.background : AppColors.textPrimary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? accent : AppColors.cardBackground)
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? .clear : accent.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
