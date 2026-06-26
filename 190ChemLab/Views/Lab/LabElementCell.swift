import SwiftUI

struct LabElementCell: View {
    let element: Element
    let slotNumber: Int?
    let onTap: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                ZStack(alignment: .topTrailing) {
                    ElementOrbView(element: element, size: 48, showGlow: slotNumber != nil)

                    if let slotNumber {
                        Text("\(slotNumber)")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(AppColors.background)
                            .frame(width: 16, height: 16)
                            .background(Circle().fill(AppColors.accent))
                            .offset(x: 4, y: -4)
                    }
                }

                Text(element.symbol)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.textPrimary)

                Text(element.name)
                    .font(.system(size: 9))
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        slotNumber != nil
                        ? Color(hex: element.color).opacity(0.18)
                        : AppColors.cardBackground
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(
                        slotNumber != nil ? Color(hex: element.color) : Color(hex: element.color).opacity(0.15),
                        lineWidth: slotNumber != nil ? 2 : 1
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
