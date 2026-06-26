import SwiftUI

struct BadgeView: View {
    let text: String
    var color: Color = AppColors.accent
    var style: Style = .filled

    enum Style {
        case filled, outline
    }

    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(style == .filled ? AppColors.background : color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(style == .filled ? color : color.opacity(0.12))
            )
            .overlay(
                Capsule()
                    .stroke(color.opacity(style == .outline ? 0.5 : 0), lineWidth: 1)
            )
    }
}
