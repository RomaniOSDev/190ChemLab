import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            Text(icon)
                .font(.system(size: 56))
                .padding(20)
                .background(
                    Circle()
                        .fill(AppColors.cardBackground)
                        .overlay(Circle().stroke(AppColors.accent.opacity(0.2), lineWidth: 1))
                )

            Text(title)
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)

            Text(message)
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.background)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(AppColors.accent))
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
        }
        .padding()
    }
}
