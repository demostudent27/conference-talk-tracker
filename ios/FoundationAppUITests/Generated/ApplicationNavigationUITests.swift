import XCTest

final class GeneratedApplicationNavigationUITests: XCTestCase {
    @MainActor
    func testUsesBottomTabsForMainNavigation() {
        let app = XCUIApplication()
        app.launchEnvironment["APP_ROOT_URL"] = "http://127.0.0.1:1"
        app.launch()

        XCTAssertEqual(app.state, .runningForeground)
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5))
        XCTAssertEqual(tabBar.buttons.count, 3)
        XCTAssertEqual(
            tabBar.buttons.element(boundBy: 0).label,
            "Speakers"
        )
        XCTAssertEqual(
            tabBar.buttons.element(boundBy: 1).label,
            "Conferences"
        )
        XCTAssertEqual(
            tabBar.buttons.element(boundBy: 2).label,
            "Talks"
        )
    }
}
