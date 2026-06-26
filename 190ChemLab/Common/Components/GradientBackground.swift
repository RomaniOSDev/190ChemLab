import SwiftUI

struct GradientBackground: View {
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            RadialGradient(
                colors: [
                    AppColors.accent.opacity(0.08),
                    .clear
                ],
                center: .topTrailing,
                startRadius: 20,
                endRadius: 400
            )
            .ignoresSafeArea()

            RadialGradient(
                colors: [
                    AppColors.danger.opacity(0.05),
                    .clear
                ],
                center: .bottomLeading,
                startRadius: 10,
                endRadius: 350
            )
            .ignoresSafeArea()

            GridPattern()
                .opacity(0.04)
                .ignoresSafeArea()
        }
    }
}

private struct GridPattern: View {
    var body: some View {
        Canvas { context, size in
            let step: CGFloat = 28
            var path = Path()
            stride(from: 0, through: size.width, by: step).forEach { x in
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
            }
            stride(from: 0, through: size.height, by: step).forEach { y in
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
            }
            context.stroke(path, with: .color(.white), lineWidth: 0.5)
        }
    }
}
