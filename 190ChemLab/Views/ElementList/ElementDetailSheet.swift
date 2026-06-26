import SwiftUI

struct ElementDetailSheet: View {
    let element: Element
    var onEdit: (() -> Void)?
    var onDelete: (() -> Void)?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                ScrollView {
                    VStack(spacing: 24) {
                        ElementOrbView(element: element, size: 100)
                            .padding(.top, 20)

                        VStack(spacing: 6) {
                            Text(element.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.textPrimary)
                            BadgeView(text: element.symbol, color: Color(hex: element.color))
                        }

                        GlassCard(accent: Color(hex: element.color)) {
                            VStack(alignment: .leading, spacing: 16) {
                                detailRow(icon: "tag.fill", title: "Category", value: "\(element.category.icon) \(element.category.rawValue)")
                                detailRow(icon: "paintpalette.fill", title: "Color", value: element.color)
                                detailRow(icon: element.isDiscovered ? "checkmark.seal.fill" : "lock.fill",
                                          title: "Status",
                                          value: element.isDiscovered ? "Discovered" : "Hidden")
                                detailRow(icon: "text.alignleft", title: "Properties", value: element.properties)
                            }
                            .padding(20)
                        }

                        if onEdit != nil || onDelete != nil {
                            HStack(spacing: 12) {
                                if let onEdit {
                                    AnimatedButton(title: "Edit", icon: "pencil", color: AppColors.accent, action: {
                                        dismiss()
                                        onEdit()
                                    })
                                }
                                if let onDelete {
                                    AnimatedButton(title: "Delete", icon: "trash", color: AppColors.danger, action: {
                                        dismiss()
                                        onDelete()
                                    })
                                }
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(AppColors.accent)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(AppColors.accent)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(AppColors.textPrimary)
            }
            Spacer()
        }
    }
}
