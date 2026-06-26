import SwiftUI

struct ElementOrbView: View {
    let element: Element
    var size: CGFloat = 56
    var showGlow: Bool = true

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(hex: element.color).opacity(0.55),
                            Color(hex: element.color).opacity(0.15),
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.6
                    )
                )
                .frame(width: size, height: size)

            Circle()
                .stroke(Color(hex: element.color).opacity(0.6), lineWidth: 1.5)
                .frame(width: size * 0.88, height: size * 0.88)

            Text(element.emoji)
                .font(.system(size: size * 0.42))
        }
        .modifier(ConditionalGlow(color: Color(hex: element.color), enabled: showGlow, radius: 8))
    }
}

private struct ConditionalGlow: ViewModifier {
    let color: Color
    let enabled: Bool
    let radius: CGFloat

    func body(content: Content) -> some View {
        if enabled {
            content.glow(color: color, radius: radius)
        } else {
            content
        }
    }
}
