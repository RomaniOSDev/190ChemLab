import SwiftUI

struct ElementCardView: View {
    let element: Element
    var onTap: (() -> Void)?
    var onEdit: (() -> Void)?
    var onDelete: (() -> Void)?

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: 14) {
                ElementOrbView(element: element, size: 58)

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(element.name)
                            .font(.headline)
                            .foregroundColor(AppColors.textPrimary)
                        BadgeView(text: element.symbol, color: Color(hex: element.color), style: .outline)
                    }

                    HStack(spacing: 6) {
                        Text(element.category.icon)
                        Text(element.category.rawValue)
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }

                    Text(element.properties)
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    HStack(spacing: 8) {
                        if element.isDiscovered {
                            Label("Discovered", systemImage: "checkmark.seal.fill")
                                .font(.caption2)
                                .foregroundColor(AppColors.accent)
                        } else {
                            Label("Hidden", systemImage: "lock.fill")
                                .font(.caption2)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                }

                Spacer(minLength: 0)

                VStack(spacing: 10) {
                    if let onEdit {
                        actionButton(icon: "pencil", color: AppColors.accent, action: onEdit)
                    }
                    if let onDelete {
                        actionButton(icon: "trash", color: AppColors.danger, action: onDelete)
                    }
                    if onEdit == nil && onDelete == nil {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color(hex: element.color).opacity(0.4),
                                        Color(hex: element.color).opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .opacity(element.isDiscovered ? 1 : 0.75)
        }
        .buttonStyle(.plain)
    }

    private func actionButton(icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
                .frame(width: 32, height: 32)
                .background(Circle().fill(color.opacity(0.12)))
        }
        .buttonStyle(.plain)
    }
}

struct ElementGridCardView: View {
    let element: Element
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ElementOrbView(element: element, size: 52)

                Text(element.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(1)

                BadgeView(text: element.symbol, color: Color(hex: element.color), style: .outline)

                if !element.isDiscovered {
                    Image(systemName: "lock.fill")
                        .font(.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color(hex: element.color).opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
