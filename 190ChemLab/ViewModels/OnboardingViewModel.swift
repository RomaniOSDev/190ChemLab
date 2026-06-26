import SwiftUI
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0

    let pages = OnboardingPage.pages
    private let onboardingService: OnboardingServiceProtocol
    private let onComplete: () -> Void

    var isLastPage: Bool {
        currentPage == pages.count - 1
    }

    init(
        onboardingService: OnboardingServiceProtocol = OnboardingService(),
        onComplete: @escaping () -> Void
    ) {
        self.onboardingService = onboardingService
        self.onComplete = onComplete
    }

    func nextPage() {
        guard currentPage < pages.count - 1 else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPage += 1
        }
    }

    func skip() {
        finish()
    }

    func completeOnboarding() {
        finish()
    }

    private func finish() {
        onboardingService.markOnboardingCompleted()
        onComplete()
    }
}
