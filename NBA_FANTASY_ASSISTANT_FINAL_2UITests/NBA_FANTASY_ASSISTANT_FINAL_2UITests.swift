import XCTest

final class NBA_FANTASY_ASSISTANT_FINAL_2UITests: XCTestCase {

    override func setUpWithError() throws {

        continueAfterFailure = false


    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
