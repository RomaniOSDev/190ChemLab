import SwiftUI

struct ReactionAnimationView: View {
    let element1: Element?
    let element2: Element?

    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var pulse = false

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            AppColors.accent.opacity(0.5),
                            AppColors.accent.opacity(0.15),
                            .clear
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 140
                    )
                )
                .frame(width: 280, height: 280)
                .scaleEffect(pulse ? 1.2 : 0.9)

            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .stroke(AppColors.accent.opacity(0.3 - Double(i) * 0.08), lineWidth: 2)
                    .frame(width: 120 + CGFloat(i) * 40, height: 120 + CGFloat(i) * 40)
                    .scaleEffect(pulse ? 1.1 : 0.95)
            }

            HStack(spacing: 28) {
                if let element1 {
                    Text(element1.emoji)
                        .font(.system(size: 52))
                        .rotationEffect(.degrees(rotation))
                        .glow(color: Color(hex: element1.color), radius: 12)
                }

                VStack(spacing: 6) {
                    Image(systemName: "bolt.fill")
                        .font(.title)
                        .foregroundColor(AppColors.accent)
                    Text("Mixing...")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.accent)
                }
                .scaleEffect(scale)

                if let element2 {
                    Text(element2.emoji)
                        .font(.system(size: 52))
                        .rotationEffect(.degrees(-rotation))
                        .glow(color: Color(hex: element2.color), radius: 12)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                rotation = 20
                scale = 1.15
                pulse = true
            }
        }
    }
}
