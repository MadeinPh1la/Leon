//
//  LeonUITests.swift
//  LeonUITests
//
//  Created by Kevin Downey on 1/18/24.
//

//
//  LeonUITests.swift
//  LeonUITests
//
//  Created by Kevin Downey on 1/18/24.
//

import XCTest

final class LeonUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Add teardown code if needed.
    }
    
    // Test fetching Stock quote data
    func testFetchingStockQuoteDisplaysDetails() {
        let app = XCUIApplication()
        app.launch()
        
        let symbolTextField = app.textFields["Enter Stock Symbol"]
        XCTAssertTrue(symbolTextField.exists)
        symbolTextField.tap()
        symbolTextField.typeText("AAPL")
        
        let fetchButton = app.buttons["Fetch"]
        XCTAssertTrue(fetchButton.exists)
        fetchButton.tap()
        
        let stockSymbolLabel = app.staticTexts["SymbolLabel"] // Use the actual accessibility identifier
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: stockSymbolLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(stockSymbolLabel.label, "AAPL", "Displayed stock symbol should be AAPL.")
    }

    // Test button functionality and loading
    
    func testUILoadingStateAppearsDuringDataFetch() {
        let app = XCUIApplication()
        app.launch()

        let fetchDataButton = app.buttons["fetchDataButton"]
        fetchDataButton.tap()
        
        let loadingIndicator = app.activityIndicators["loadingIndicator"]
        XCTAssertTrue(loadingIndicator.exists, "Loading indicator should be present while fetching data.")
    }
    
    // Test UI error state display
    
    func testUIErrorStateDisplaysOnError() {
        let app = XCUIApplication()
        app.launchEnvironment = ["UITestMockErrorState": "1"] // Environment variable to simulate error
        app.launch()
        
        let fetchDataButton = app.buttons["fetchDataButton"]
        fetchDataButton.tap()
        
        let errorMessage = app.staticTexts["errorMessage"]
        XCTAssertTrue(errorMessage.exists, "Error message should be displayed on data fetch failure.")
    }
    
    // Test UI recovery from error state
    
    func testUIRecoveryFromErrorState() {
        let app = XCUIApplication()
        app.launchEnvironment = ["UITestMockErrorState": "1"] // Start with an error state
        app.launch()
        
        let retryButton = app.buttons["retryButton"]
        XCTAssertTrue(retryButton.exists, "Retry button should be available in error state.")
        
        app.launchEnvironment = ["UITestMockErrorState": "0"]
        
        retryButton.tap()
        
        let errorMessage = app.staticTexts["errorMessage"]
        XCTAssertFalse(errorMessage.exists, "Error message should not be present after successful data fetch.")
    }

    // Test launch performace
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
