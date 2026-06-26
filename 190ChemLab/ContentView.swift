import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                mainApp
                    .transition(.opacity)
            } else {
                OnboardingView(
                    viewModel: OnboardingViewModel {
                        hasCompletedOnboarding = true
                    }
                )
                .transition(.opacity)
            }
        }
        .preferredColorScheme(.dark)
        .animation(.easeInOut(duration: 0.4), value: hasCompletedOnboarding)
    }

    private var mainApp: some View {
        NavigationStack(path: $coordinator.path) {
            HomeView(
                viewModel: HomeViewModel(coordinator: coordinator),
                coordinator: coordinator
            )
            .navigationDestination(for: AppRoute.self) { route in
                coordinator.destination(for: route)
            }
        }
        .tint(AppColors.accent)
    }
}

#Preview {
    ContentView()
}
