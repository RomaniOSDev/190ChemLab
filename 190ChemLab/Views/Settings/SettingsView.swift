import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    appInfoCard
                    dataSection
                    legalSection
                    aboutSection
                }
                .padding(16)
                .readableContentWidth()
                .padding(.bottom, 48)
                .frame(maxWidth: .infinity, alignment: .top)
            }
            .clearScrollBackground()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(AppColors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: viewModel.goBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(AppColors.accent)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)
            }
        }
        .alert("Reset All Data?", isPresented: $viewModel.showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                viewModel.resetAllData()
            }
        } message: {
            Text("This will delete all progress, elements, reactions, and inventory. This action cannot be undone.")
        }
    }

    private var appInfoCard: some View {
        GlassCard(accent: AppColors.accent) {
            HStack(spacing: 16) {
                Text("🧪")
                    .font(.system(size: 44))
                    .padding(12)
                    .background(
                        Circle()
                            .fill(AppColors.accent.opacity(0.12))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text("Virtual Laboratory")
                        .font(.headline)
                        .foregroundColor(AppColors.textPrimary)
                    Text("Education & Science")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    BadgeView(text: "v1.0", color: AppColors.accent, style: .outline)
                }
                Spacer()
            }
            .padding(16)
        }
    }

    private var dataSection: some View {
        VStack(spacing: 8) {
            SectionHeaderView(title: "Data", subtitle: "Manage your progress")

            GlassCard(accent: AppColors.danger) {
                Button {
                    viewModel.showResetAlert = true
                } label: {
                    SettingRowView(
                        icon: "trash.fill",
                        title: "Reset All Data",
                        subtitle: "Clear progress and start over",
                        iconColor: AppColors.danger,
                        titleColor: AppColors.danger,
                        showChevron: true
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var legalSection: some View {
        VStack(spacing: 8) {
            SectionHeaderView(title: "Legal", subtitle: "Rate and policies")

            GlassCard(accent: AppColors.accentWarning) {
                VStack(spacing: 0) {
                    settingsButton(icon: "star.fill", title: "Rate Us", subtitle: "Enjoying the app? Leave a review", iconColor: AppColors.accentWarning) {
                        viewModel.rateApp()
                    }
                    rowDivider
                    settingsButton(icon: "hand.raised.fill", title: "Privacy Policy", subtitle: "How we handle your data", iconColor: AppColors.accent) {
                        viewModel.openPrivacyPolicy()
                    }
                    rowDivider
                    settingsButton(icon: "doc.text.fill", title: "Terms of Use", subtitle: "Rules for using the app", iconColor: AppColors.textSecondary) {
                        viewModel.openTermsOfUse()
                    }
                }
            }
        }
    }

    private var aboutSection: some View {
        VStack(spacing: 8) {
            SectionHeaderView(title: "About", subtitle: "App information")

            GlassCard {
                VStack(spacing: 0) {
                    SettingRowView(
                        icon: "info.circle.fill",
                        title: "Storage",
                        subtitle: "Local data on device",
                        iconColor: AppColors.accentWarning,
                        trailing: "UserDefaults"
                    )
                    rowDivider
                    SettingRowView(
                        icon: "iphone",
                        title: "Platform",
                        subtitle: "iOS 17+",
                        iconColor: AppColors.textSecondary,
                        trailing: "SwiftUI"
                    )
                }
            }
        }
    }

    private var rowDivider: some View {
        Divider()
            .background(AppColors.textSecondary.opacity(0.1))
            .padding(.leading, 70)
    }

    private func settingsButton(
        icon: String,
        title: String,
        subtitle: String,
        iconColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            SettingRowView(
                icon: icon,
                title: title,
                subtitle: subtitle,
                iconColor: iconColor,
                showChevron: true
            )
        }
        .buttonStyle(.plain)
    }
}
