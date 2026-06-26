import SwiftUI

struct ElementFormView: View {
    @StateObject private var viewModel: ElementFormViewModel

    private let presetColors = ["#06dbab", "#ff2300", "#ffa500", "#4169E1", "#FFD700", "#808080", "#FFFFFF", "#2F2F2F"]

    init(viewModel: ElementFormViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView {
                VStack(spacing: 20) {
                    previewCard
                    emojiSection
                    formSection(title: "Basic Info") {
                        formField(title: "Name", text: $viewModel.name, placeholder: "Element name")
                        formField(title: "Symbol", text: $viewModel.symbol, placeholder: "e.g. Fe")
                    }
                    formSection(title: "Category") { categoryPicker }
                    formSection(title: "Appearance") { colorPicker }
                    formSection(title: "Description") {
                        formField(title: "Properties", text: $viewModel.properties, placeholder: "Describe the element...", axis: .vertical)
                    }

                    AnimatedButton(
                        title: viewModel.isEditing ? "Save Changes" : "Create Element",
                        icon: "checkmark",
                        color: viewModel.isFormValid ? AppColors.accent : Color.gray.opacity(0.4)
                    ) {
                        viewModel.saveElement()
                    }
                    .disabled(!viewModel.isFormValid)
                }
                .padding(20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(AppColors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", action: viewModel.cancel)
                    .foregroundColor(AppColors.danger)
            }
            ToolbarItem(placement: .principal) {
                Text(viewModel.screenTitle)
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)
            }
        }
    }

    private var previewCard: some View {
        GlassCard(accent: Color(hex: viewModel.color)) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(hex: viewModel.color).opacity(0.2))
                        .frame(width: 72, height: 72)
                    Text(viewModel.emoji).font(.system(size: 36))
                }
                .glow(color: Color(hex: viewModel.color))

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.name.isEmpty ? "Element Name" : viewModel.name)
                        .font(.headline)
                        .foregroundColor(AppColors.textPrimary)
                    BadgeView(
                        text: viewModel.symbol.isEmpty ? "?" : viewModel.symbol,
                        color: Color(hex: viewModel.color)
                    )
                    Text(viewModel.selectedCategory.rawValue)
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                Spacer()
            }
            .padding(16)
        }
    }

    private var emojiSection: some View {
        formSection(title: "Emoji") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
                ForEach(viewModel.presetEmojis, id: \.self) { emoji in
                    Button {
                        viewModel.emoji = emoji
                    } label: {
                        Text(emoji)
                            .font(.title2)
                            .frame(width: 48, height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(viewModel.emoji == emoji ? AppColors.accent.opacity(0.2) : AppColors.cardBackground)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(viewModel.emoji == emoji ? AppColors.accent : .clear, lineWidth: 2)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func formSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.textSecondary)
            GlassCard {
                VStack(spacing: 12) { content() }
                    .padding(16)
            }
        }
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ElementCategory.allCases, id: \.self) { category in
                    FilterChipView(
                        category.rawValue,
                        icon: category.icon,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        viewModel.selectedCategory = category
                    }
                }
            }
        }
    }

    private var colorPicker: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                ForEach(presetColors, id: \.self) { hex in
                    Circle()
                        .fill(Color(hex: hex))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Circle()
                                .stroke(viewModel.color == hex ? AppColors.textPrimary : .clear, lineWidth: 2.5)
                        )
                        .shadow(color: Color(hex: hex).opacity(0.4), radius: viewModel.color == hex ? 6 : 0)
                        .onTapGesture { viewModel.color = hex }
                }
            }
            TextField("Hex color", text: $viewModel.color)
                .foregroundColor(AppColors.textPrimary)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(AppColors.background.opacity(0.5))
                )
        }
    }

    private func formField(
        title: String,
        text: Binding<String>,
        placeholder: String,
        axis: Axis = .horizontal
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
            TextField(placeholder, text: text, axis: axis)
                .lineLimit(axis == .vertical ? 3...6 : 1...1)
                .foregroundColor(AppColors.textPrimary)
        }
    }
}
