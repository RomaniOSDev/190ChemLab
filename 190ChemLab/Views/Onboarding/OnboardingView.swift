import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 0) {
                headerBar

                TabView(selection: $viewModel.currentPage) {
                    ForEach(viewModel.pages) { page in
                        OnboardingPageView(page: page)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)

                pageIndicator
                actionButtons
            }
        }
        .preferredColorScheme(.dark)
    }

    private var headerBar: some View {
        HStack {
            Text("🧪")
                .font(.title2)

            Spacer()

            if !viewModel.isLastPage {
                Button("Skip") {
                    viewModel.skip()
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.pages) { page in
                Capsule()
                    .fill(
                        viewModel.currentPage == page.id
                        ? viewModel.pages[viewModel.currentPage].accent
                        : AppColors.textSecondary.opacity(0.3)
                    )
                    .frame(width: viewModel.currentPage == page.id ? 28 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.25), value: viewModel.currentPage)
            }
        }
        .padding(.bottom, 24)
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            if viewModel.isLastPage {
                AnimatedButton(
                    title: "Get Started",
                    icon: "arrow.right",
                    color: AppColors.accent
                ) {
                    viewModel.completeOnboarding()
                }
            } else {
                AnimatedButton(
                    title: "Continue",
                    icon: "chevron.right",
                    color: viewModel.pages[viewModel.currentPage].accent
                ) {
                    viewModel.nextPage()
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }
}
