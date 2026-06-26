import Foundation

protocol OnboardingServiceProtocol {
    var hasCompletedOnboarding: Bool { get }
    func markOnboardingCompleted()
    func resetOnboarding()
}

final class OnboardingService: OnboardingServiceProtocol {
    private let key = "hasCompletedOnboarding"

    var hasCompletedOnboarding: Bool {
        UserDefaults.standard.bool(forKey: key)
    }

    func markOnboardingCompleted() {
        UserDefaults.standard.set(true, forKey: key)
    }

    func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: key)
    }
}
