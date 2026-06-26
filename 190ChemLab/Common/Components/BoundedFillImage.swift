import SwiftUI

/// Fills a parent-bounded frame without expanding horizontal layout (fixes ScrollView overflow).
struct BoundedFillImage: View {
    let name: String
    var height: CGFloat
    var cornerRadius: CGFloat = 0

    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .overlay {
                Image(name)
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

extension View {
    func homeRowWidth() -> some View {
        frame(minWidth: 0, maxWidth: .infinity)
    }
}
