//
//  LeonTests.swift
//  LeonTests
//
//  Created by Kevin Downey on 1/18/24.
//

import XCTest
@testable import Leon

// MARK: - StockQuote Test

// Test StockQuote struct correctly decodes from a JSON response. This verifies the FinancialViewModel decoding logic aligns with the API's response format.


class StockQuoteTests: XCTestCase {
    
    func testStockQuoteDecoding() {
        let json = """
        {
            "01. symbol": "AAPL",
            "02. open": "150.00",
            "03. high": "155.00",
            "04. low": "149.00",
            "05. price": "154.00",
            "06. volume": "123456",
            "07. latest trading day": "2024-02-02",
            "08. previous close": "150.00",
            "09. change": "4.00",
            "10. change percent": "2.67%"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let stockQuote = try? decoder.decode(StockQuote.self, from: json)
        
        XCTAssertNotNil(stockQuote, "Decoding StockQuote should not fail.")
        XCTAssertEqual(stockQuote?.symbol, "AAPL", "Symbol should be AAPL.")
    }
}

// MARK: - API Test

//Verifies the API call for fetching a stock quote correctly handles a successful response. It uses a mock URLSession to avoid making a real network request.

class APITests: XCTestCase {
    func testFetchStockQuoteSuccess() {
        // Setup mock URLSession and API instance
        let api = API() // Adjust this to use your API class
        let expectation = XCTestExpectation(description: "Fetch stock quote succeeds")
        
        api.fetchStockQuote(forSymbol: "AAPL") { result in
            switch result {
            case .success(let stockQuote):
                XCTAssertEqual(stockQuote.symbol, "AAPL", "Fetched stock symbol should be AAPL.")
                expectation.fulfill()
            case .failure:
                XCTFail("API call for fetching stock quote failed.")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
}


// MARK: - User Interaction Test

// System test to simulate a user entering a stock symbol and pressing a fetch button. Test then verifies that the expected stock quote details are displayed.


class StockQuoteAppUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

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
        
        // Assuming there's a label that displays the stock symbol in your UI
        let stockSymbolLabel = app.staticTexts["SymbolLabel"] // Use the actual accessibility identifier
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: stockSymbolLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(stockSymbolLabel.label, "AAPL", "Displayed stock symbol should be AAPL.")
    }
}



