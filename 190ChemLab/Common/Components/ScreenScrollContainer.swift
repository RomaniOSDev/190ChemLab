import SwiftUI

private enum LayoutMetrics {
    static let readableMaxWidth: CGFloat = 640
    static let horizontalPadding: CGFloat = 16
}

struct ReadableContentModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: horizontalSizeClass == .regular ? LayoutMetrics.readableMaxWidth : .infinity)
            .frame(maxWidth: .infinity)
    }
}

extension View {
    func readableContentWidth() -> some View {
        modifier(ReadableContentModifier())
    }

    func clearScrollBackground() -> some View {
        scrollContentBackground(.hidden)
            .background(Color.clear)
    }
}

struct ScreenScrollContainer<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(.vertical, showsIndicators: true) {
                content()
                    .padding(.horizontal, LayoutMetrics.horizontalPadding)
                    .padding(.top, 12)
                    .padding(.bottom, 48)
                    .readableContentWidth()
                    .frame(maxWidth: .infinity, alignment: .top)
            }
            .clearScrollBackground()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
