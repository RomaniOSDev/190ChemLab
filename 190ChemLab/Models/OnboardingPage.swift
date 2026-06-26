import SwiftUI

struct OnboardingPage: Identifiable {
    let id: Int
    let imageName: String
    let title: String
    let subtitle: String
    let accent: Color

    static let pages: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            imageName: "HomeHero",
            title: "Welcome to the Lab",
            subtitle: "Mix chemical elements in a virtual laboratory and explore the world of science through hands-on experiments.",
            accent: AppColors.accent
        ),
        OnboardingPage(
            id: 1,
            imageName: "WidgetElements",
            title: "Discover Elements",
            subtitle: "Collect metals, gases, acids, and organic compounds. Unlock hidden elements by combining the right substances.",
            accent: AppColors.danger
        ),
        OnboardingPage(
            id: 2,
            imageName: "WidgetReactions",
            title: "Master Reactions",
            subtitle: "Find new reactions, earn points, and fill your reaction book. Every experiment brings you closer to completion.",
            accent: AppColors.accentWarning
        )
    ]
}
