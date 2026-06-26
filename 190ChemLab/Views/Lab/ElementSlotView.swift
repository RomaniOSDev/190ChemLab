import SwiftUI

struct ElementSlotView: View {
    let element: Element?
    var slotLabel: String = "Slot"
    var accent: Color = AppColors.accent
    var onTap: (() -> Void)?

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        element != nil
                        ? Color(hex: element!.color).opacity(0.15)
                        : AppColors.cardBackground
                    )
                    .frame(width: 96, height: 96)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(
                                element != nil
                                ? Color(hex: element!.color)
                                : accent.opacity(0.3),
                                style: StrokeStyle(lineWidth: 2, dash: element == nil ? [6, 4] : [])
                            )
                    )

                if let element {
                    VStack(spacing: 4) {
                        Text(element.emoji).font(.system(size: 36))
                        Text(element.symbol)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.textPrimary)
                    }
                    .glow(color: Color(hex: element.color), radius: 8)
                } else {
                    VStack(spacing: 4) {
                        Image(systemName: "plus.circle")
                            .font(.title)
                            .foregroundColor(accent.opacity(0.6))
                        Text("Tap to clear")
                            .font(.system(size: 8))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }

            Text(element?.name ?? slotLabel)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(element != nil ? AppColors.textPrimary : AppColors.textSecondary)
                .lineLimit(1)
                .frame(width: 96)
        }
        .onTapGesture { onTap?() }
    }
}
