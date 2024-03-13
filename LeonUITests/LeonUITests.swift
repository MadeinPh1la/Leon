//
//  LeonUITests.swift
//  LeonUITests
//
//  Created by Kevin Downey on 1/18/24.
//

import XCTest

final class LeonUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Test UI Loading State Appears During Data Fetch

    func testUILoadingStateAppearsDuringDataFetch() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

            // Test button functionality
            let fetchDataButton = app.buttons["fetchDataButton"]
            fetchDataButton.tap()

            // Check for the presence of a loading indicator
            let loadingIndicator = app.activityIndicators["loadingIndicator"]
            XCTAssertTrue(loadingIndicator.exists, "Loading indicator should be present while fetching data.")
        }
    
    // Test UI Error State Displays On Error
    
    func testUIErrorStateDisplaysOnError() {
        let app = XCUIApplication()
        app.launchEnvironment = ["UITestMockErrorState": "1"] // Environment variable to simulate error
        app.launch()

        // Triggering the data fetch, assuming it results in an error
        let fetchDataButton = app.buttons["fetchDataButton"]
        fetchDataButton.tap()

        // Check for the presence of an error message
        let errorMessage = app.staticTexts["errorMessage"]
        XCTAssertTrue(errorMessage.exists, "Error message should be displayed on data fetch failure.")
    }

    // Test UI Recovery From Error State
    
    func testUIRecoveryFromErrorState() {
        let app = XCUIApplication()
        app.launchEnvironment = ["UITestMockErrorState": "1"] // Start with an error state
        app.launch()

        // Assuming there's a "Retry" button to fetch data again
        let retryButton = app.buttons["retryButton"]
        XCTAssertTrue(retryButton.exists, "Retry button should be available in error state.")

        // Clear the mock error state before retry
        app.launchEnvironment = ["UITestMockErrorState": "0"]
        
        // Tap the retry button to attempt data fetch again
        retryButton.tap()

        // Verify recovery by checking the error message is not present
        let errorMessage = app.staticTexts["errorMessage"]
        XCTAssertFalse(errorMessage.exists, "Error message should not be present after successful data fetch.")
        
        // Optionally, verify some expected element appears after successful fetch
    }

        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
