import SwiftUI

struct SectionHeaderView: View {
    let title: String
    var subtitle: String? = nil
    var count: Int? = nil
    var accent: Color = AppColors.accent

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            Spacer()
            if let count {
                Text("\(count)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(accent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(accent.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
    }
}
