import Foundation
import HotwireNative
import Testing
import UIKit
import WebKit

@testable import FoundationApp

@Suite(.serialized)
@MainActor
struct SafeAreaLayoutTests {
    @Test
    func keepsSingleNavigatorWebContentAtTheSafeAreaEdges() async throws {
        try await expectWebContentAtSafeAreaEdges(withTabBar: false)
    }

    @Test
    func keepsTabbedWebContentAtTheSafeAreaEdges() async throws {
        try await expectWebContentAtSafeAreaEdges(withTabBar: true)
    }

    private func expectWebContentAtSafeAreaEdges(
        withTabBar: Bool
    ) async throws {
        let windowScene = try #require(
            UIApplication.shared.connectedScenes.compactMap {
                $0 as? UIWindowScene
            }.first
        )
        let window = UIWindow(windowScene: windowScene)
        let startURL = URL(string: "about:blank")!
        let firstEntry = HotwireTab(
            id: "first",
            title: "First",
            image: nil,
            url: startURL
        )
        let entries =
            withTabBar
            ? [
                firstEntry,
                HotwireTab(
                    id: "second",
                    title: "Second",
                    image: nil,
                    url: startURL
                ),
            ]
            : [firstEntry]
        let navigationContainer = AppNavigationContainer(entries: entries)

        window.rootViewController = navigationContainer.rootViewController
        window.makeKeyAndVisible()
        defer { window.isHidden = true }
        navigationContainer.start()
        window.layoutIfNeeded()

        let navigationController: UINavigationController
        if let tabBarController =
            navigationContainer.rootViewController
            as? HotwireTabBarController
        {
            navigationController = try #require(
                tabBarController.navigator(for: firstEntry)?.rootViewController
            )
        } else {
            navigationController = try #require(
                navigationContainer.rootViewController
                    as? UINavigationController
            )
        }
        let controller = try #require(
            navigationController.topViewController
                as? HotwireWebViewController
        )
        controller.loadViewIfNeeded()
        window.layoutIfNeeded()
        let webView = try #require(controller.visitableView.webView)
        webView.stopLoading()

        let loader = PageLoader()
        try await loader.load(edgeSentinelPage, in: webView)

        controller.view.layoutIfNeeded()
        window.layoutIfNeeded()

        let scrollView = webView.scrollView
        try await waitForContentLayout(
            in: scrollView,
            minimumHeight: webView.bounds.height + 100
        )
        let metrics = try await PageMetrics.read(from: webView)
        let cssPointScale =
            scrollView.contentSize.height / metrics.documentHeight
        let controllerFrame = controller.view.convert(
            controller.view.bounds,
            to: window
        )
        let webFrame = webView.convert(webView.bounds, to: window)
        let safeFrame = controller.view.convert(
            controller.view.safeAreaLayoutGuide.layoutFrame,
            to: window
        )
        let navigationBarFrame = navigationController.navigationBar.convert(
            navigationController.navigationBar.bounds,
            to: window
        )
        let expectedTop = navigationBarFrame.maxY
        let expectedBottom: CGFloat
        if let tabBarController =
            navigationContainer.rootViewController
            as? HotwireTabBarController
        {
            let tabBarFrame = tabBarController.tabBar.convert(
                tabBarController.tabBar.bounds,
                to: window
            )
            expectedBottom = tabBarFrame.minY
            #expect(tabBarFrame.height > 0)
        } else {
            expectedBottom = window.bounds.maxY - window.safeAreaInsets.bottom
        }
        let topInset = safeFrame.minY - webFrame.minY
        let bottomInset = webFrame.maxY - safeFrame.maxY

        #expect(navigationBarFrame.height > 0)
        #expect(topInset > 0)
        #expect(isApproximatelyEqual(webFrame.minX, controllerFrame.minX))
        #expect(isApproximatelyEqual(webFrame.maxX, controllerFrame.maxX))
        #expect(isApproximatelyEqual(webFrame.minY, controllerFrame.minY))
        #expect(isApproximatelyEqual(webFrame.maxY, controllerFrame.maxY))
        #expect(isApproximatelyEqual(safeFrame.minY, expectedTop))
        #expect(isApproximatelyEqual(safeFrame.maxY, expectedBottom))
        #expect(isApproximatelyEqual(scrollView.adjustedContentInset.top, topInset))
        #expect(
            isApproximatelyEqual(
                scrollView.adjustedContentInset.bottom,
                bottomInset
            )
        )

        scrollView.setContentOffset(
            CGPoint(x: 0, y: -scrollView.adjustedContentInset.top),
            animated: false
        )
        let firstControlTop =
            webFrame.minY
            + metrics.firstControlTop * cssPointScale
            - scrollView.contentOffset.y

        #expect(
            isApproximatelyEqual(firstControlTop, expectedTop),
            "The first control must meet the safe-area edge without hiding or duplicate padding."
        )

        let maximumOffset = max(
            -scrollView.adjustedContentInset.top,
            scrollView.contentSize.height - scrollView.bounds.height
                + scrollView.adjustedContentInset.bottom
        )
        scrollView.setContentOffset(
            CGPoint(x: 0, y: maximumOffset),
            animated: false
        )
        let lastControlBottom =
            webFrame.minY
            + metrics.lastControlBottom * cssPointScale
            - scrollView.contentOffset.y

        #expect(
            isApproximatelyEqual(lastControlBottom, expectedBottom),
            "The last control must meet the safe-area edge without hiding or duplicate padding."
        )
    }

    private func isApproximatelyEqual(
        _ first: CGFloat,
        _ second: CGFloat
    ) -> Bool {
        abs(first - second) < 1
    }

    private func waitForContentLayout(
        in scrollView: UIScrollView,
        minimumHeight: CGFloat
    ) async throws {
        for _ in 0..<100 {
            if scrollView.contentSize.height >= minimumHeight - 1 {
                return
            }

            try await Task.sleep(nanoseconds: 10_000_000)
        }

        throw SafeAreaFixtureError.contentDidNotLayout
    }

    private var edgeSentinelPage: String {
        """
        <!doctype html>
        <html>
          <head>
            <meta name="viewport" content="width=device-width,initial-scale=1">
            <style>
              html, body { margin: 0; }
              button { display: block; height: 44px; width: 100%; }
              #spacer { height: 1200px; }
            </style>
          </head>
          <body>
            <button id="first">First</button>
            <div id="spacer"></div>
            <button id="last">Last</button>
          </body>
        </html>
        """
    }
}

@MainActor
private final class PageLoader: NSObject, WKNavigationDelegate {
    private var continuation: CheckedContinuation<Void, any Error>?
    private var expectedNavigation: WKNavigation?
    private var timeoutTask: Task<Void, Never>?

    func load(_ html: String, in webView: WKWebView) async throws {
        webView.navigationDelegate = self

        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            guard let navigation = webView.loadHTMLString(html, baseURL: nil) else {
                fail(with: SafeAreaFixtureError.navigationDidNotStart)
                return
            }

            expectedNavigation = navigation
            timeoutTask = Task { @MainActor [weak self] in
                try? await Task.sleep(nanoseconds: 5_000_000_000)
                guard !Task.isCancelled else {
                    return
                }

                self?.fail(with: SafeAreaFixtureError.pageLoadTimedOut)
            }
        }
    }

    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        guard navigation === expectedNavigation else {
            return
        }

        finish()
    }

    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: any Error
    ) {
        guard navigation === expectedNavigation else {
            return
        }

        fail(with: error)
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: any Error
    ) {
        guard navigation === expectedNavigation else {
            return
        }

        fail(with: error)
    }

    private func fail(with error: any Error) {
        timeoutTask?.cancel()
        timeoutTask = nil
        let continuation = continuation
        self.continuation = nil
        expectedNavigation = nil
        continuation?.resume(throwing: error)
    }

    private func finish() {
        timeoutTask?.cancel()
        timeoutTask = nil
        let continuation = continuation
        self.continuation = nil
        expectedNavigation = nil
        continuation?.resume()
    }
}

private struct PageMetrics {
    let documentHeight: CGFloat
    let firstControlTop: CGFloat
    let lastControlBottom: CGFloat

    @MainActor
    static func read(from webView: WKWebView) async throws -> Self {
        let value = try await webView.evaluateJavaScript(
            """
            ({
              documentHeight: document.documentElement.scrollHeight,
              firstControlTop: document.getElementById('first').getBoundingClientRect().top,
              lastControlBottom: document.getElementById('last').getBoundingClientRect().bottom
            })
            """
        )
        let object = try #require(value as? [String: Any])
        let documentHeight = try #require(
            object["documentHeight"] as? NSNumber
        )
        let firstControlTop = try #require(
            object["firstControlTop"] as? NSNumber
        )
        let lastControlBottom = try #require(
            object["lastControlBottom"] as? NSNumber
        )

        return Self(
            documentHeight: CGFloat(truncating: documentHeight),
            firstControlTop: CGFloat(truncating: firstControlTop),
            lastControlBottom: CGFloat(truncating: lastControlBottom)
        )
    }
}

private enum SafeAreaFixtureError: Error {
    case navigationDidNotStart
    case pageLoadTimedOut
    case contentDidNotLayout
}
