import SwiftUI
import Combine
import StoreKit
import UIKit

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var showResetAlert = false

    private let storageService: StorageServiceProtocol
    private let elementService: ElementService
    private let reactionEngine: ReactionEngine
    private let coordinator: AppCoordinator
    private let onboardingService: OnboardingServiceProtocol

    init(
        storageService: StorageServiceProtocol,
        elementService: ElementService,
        reactionEngine: ReactionEngine,
        coordinator: AppCoordinator,
        onboardingService: OnboardingServiceProtocol = OnboardingService()
    ) {
        self.storageService = storageService
        self.elementService = elementService
        self.reactionEngine = reactionEngine
        self.coordinator = coordinator
        self.onboardingService = onboardingService
    }

    func resetAllData() {
        storageService.delete(forKey: StorageKeys.elements)
        storageService.delete(forKey: StorageKeys.reactions)
        storageService.delete(forKey: StorageKeys.inventory)
        storageService.delete(forKey: StorageKeys.experiments)
        onboardingService.resetOnboarding()

        _ = elementService.getElements()
        reactionEngine.getDefaultReactions().forEach { reactionEngine.addReaction($0) }

        coordinator.popToRoot()
    }

    func goBack() {
        coordinator.pop()
    }

    func openPrivacyPolicy() {
        open(link: .privacyPolicy)
    }

    func openTermsOfUse() {
        open(link: .termsOfUse)
    }

    func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }

    private func open(link: AppLinks) {
        if let url = link.url {
            UIApplication.shared.open(url)
        }
    }
}
