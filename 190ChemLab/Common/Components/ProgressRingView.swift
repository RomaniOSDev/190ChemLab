import SwiftUI

struct ProgressRingView: View {
    let progress: Double
    var lineWidth: CGFloat = 10
    var size: CGFloat = 88
    var accent: Color = AppColors.accent
    var showGlow: Bool = true

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.cardBackground, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: min(progress / 100, 1))
                .stroke(
                    AngularGradient(
                        colors: [accent, accent.opacity(0.5), accent],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 0) {
                Text(String(format: "%.0f", progress))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.textPrimary)
                Text("%")
                    .font(.system(size: 9))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .frame(width: size, height: size)
        .modifier(ConditionalRingGlow(color: accent, enabled: showGlow))
        .animation(.spring(response: 0.6), value: progress)
    }
}

private struct ConditionalRingGlow: ViewModifier {
    let color: Color
    let enabled: Bool

    func body(content: Content) -> some View {
        if enabled {
            content.shadow(color: color.opacity(0.35), radius: 4)
        } else {
            content
        }
    }
}
