import SwiftUI
import UIKit

private enum LayoutMetrics {
    static let readableMaxWidth: CGFloat = 640
    static let horizontalPadding: CGFloat = 16
}

struct ReadableContentModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: horizontalSizeClass == .regular ? LayoutMetrics.readableMaxWidth : .infinity)
            .frame(maxWidth: .infinity)
    }
}

extension View {
    func readableContentWidth() -> some View {
        modifier(ReadableContentModifier())
    }

    func clearScrollBackground() -> some View {
        scrollContentBackground(.hidden)
            .background(Color.clear)
    }
}

struct ScreenScrollContainer<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            GradientBackground()

            UIKitScrollView {
                content()
                    .padding(.horizontal, LayoutMetrics.horizontalPadding)
                    .padding(.top, 12)
                    .padding(.bottom, 48)
                    .readableContentWidth()
                    .frame(maxWidth: .infinity, alignment: .top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// UIKit-backed vertical scroll — reliable on iPad when large buttons fill the viewport.
struct UIKitScrollView<Content: View>: UIViewControllerRepresentable {
    @ViewBuilder var content: () -> Content

    func makeUIViewController(context: Context) -> UIKitScrollViewController<Content> {
        UIKitScrollViewController(rootView: content())
    }

    func updateUIViewController(_ controller: UIKitScrollViewController<Content>, context: Context) {
        controller.update(rootView: content())
    }
}

final class UIKitScrollViewController<Content: View>: UIViewController {
    private let scrollView = UIScrollView()
    private let hostingController: UIHostingController<Content>

    init(rootView: Content) {
        hostingController = UIHostingController(rootView: rootView)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .automatic
        scrollView.delaysContentTouches = true
        scrollView.canCancelContentTouches = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 16.4, *) {
            hostingController.safeAreaRegions = []
        }

        addChild(hostingController)
        scrollView.addSubview(hostingController.view)
        view.addSubview(scrollView)
        hostingController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    func update(rootView: Content) {
        hostingController.rootView = rootView
        hostingController.view.setNeedsLayout()
        hostingController.view.layoutIfNeeded()
        view.setNeedsLayout()
    }
}
