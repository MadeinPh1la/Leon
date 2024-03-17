//
//  LeonTests.swift
//  LeonTests
//
//  Created by Kevin Downey on 1/18/24.
//

import XCTest
import Combine
@testable import Leon

class APITests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var apiService: APIService!
    private var mockAPIService: MockAPIService!

    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mockAPIService = MockAPIService()
        apiService = mockAPIService // Use the mock service
    }

    override func tearDown() {
        cancellables = nil
        mockAPIService = nil
        apiService = nil
        super.tearDown()
    }
    
    // Test fetching Stock Quote data
    
    func testFetchStockQuoteSuccess() {
        // Setup: Initialize the mockAPIService with expected mock data
        let mockStockQuote = StockQuoteResponse(globalQuote: StockQuote(symbol: "AAPL",
                                                                         open: "150.00",
                                                                         high: "152.00",
                                                                         low: "148.00",
                                                                         price: "151.00",
                                                                         volume: "100000",
                                                                         latestTradingDay: "2023-03-16",
                                                                         previousClose: "150.00",
                                                                         change: "1.00",
                                                                         changePercent: "0.67%"))
        mockAPIService.mockStockQuoteResponse = Just(mockStockQuote)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        // Expectation: The async operation should complete with specific results
        let expectation = XCTestExpectation(description: "Fetch stock quote")

        // Execution: Use the mock service to fetch the stock quote
        apiService.fetchStockQuote(forSymbol: "AAPL")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Failed with error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { stockQuoteResponse in
                // Verification: Assert that the received values are as expected
                XCTAssertEqual(stockQuoteResponse.globalQuote.symbol, "AAPL", "The symbol should match.")
                XCTAssertEqual(stockQuoteResponse.globalQuote.price, "151.00", "The price should match.")
                expectation.fulfill()  // Mark the expectation as fulfilled
            })
            .store(in: &cancellables)

        // Wait for the expectation to be fulfilled, or time out after 5 seconds
        wait(for: [expectation], timeout: 200.0)
    }

    
    // Test fetching Company Overview data
    func testFetchCompanyOverviewSuccess() {
        let mockCompanyOverview = CompanyOverview(symbol: "AAPL", name: "Apple Inc.", description: "Apple Inc. designs, manufactures, and markets mobile communication and media devices.", marketCapitalization: "2T", sharesOutstanding: "100B")
        mockAPIService.mockCompanyOverviewResponse = Just(mockCompanyOverview).setFailureType(to: Error.self).eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "fetchCompanyOverview completes")
        
        apiService.fetchCompanyOverview(forSymbol: "AAPL")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Request failed with error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { overview in
                XCTAssertEqual(overview.symbol, "AAPL")
                XCTAssertEqual(overview.name, "Apple Inc.")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // Test fetching Cash Flow data
    
    func testFetchCashFlowDataSuccess() {
        // Create a mock CashFlowResponse object directly instead of using a JSON string
        let mockCashFlowResponse = CashFlowResponse(symbol: "AAPL", annualReports: [
            AnnualCashFlowReport(
                fiscalDateEnding: "2020-09-30",
                reportedCurrency: "USD",
                operatingCashflow: "100000000",
                capitalExpenditures: "-50000000",
                netIncome: "40000000"
            )
        ])
        
        // Set the mock response in your mockAPIService
        mockAPIService.mockCashFlowResponse = Just(mockCashFlowResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "fetchCashFlowData completes")
        
        // Use apiService which is your mockAPIService injected into the test environment
        apiService.fetchCashFlowData(forSymbol: "AAPL")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Request failed with error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { cashFlowResponse in
                XCTAssertNotNil(cashFlowResponse.annualReports.first)
                XCTAssertEqual(cashFlowResponse.symbol, "AAPL")
                // Additional assertions can be made here based on the mock data
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }

    
    // Test fetching Income Statement data
    
    func testFetchIncomeStatementSuccess() {
        // Create a mock IncomeStatementData object directly instead of using a JSON string
        let mockIncomeStatementData = IncomeStatementData(symbol: "AAPL", annualReports: [
            AnnualIncomeStatementReport(
                fiscalDateEnding: "2020-09-30",
                reportedCurrency: "USD",
                grossProfit: "104956000000", 
                totalRevenue: "274515000000",
                operatingIncome: "66288000000",
                netIncome: "57411000000",
                ebit: "55000000000"
            )
        ])
        
        // Set the mock response in your mockAPIService
        mockAPIService.mockIncomeStatementResponse = Just(mockIncomeStatementData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "fetchIncomeStatement completes")
        
        // Use apiService which is your mockAPIService injected into the test environment
        apiService.fetchIncomeStatement(forSymbol: "AAPL")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Request failed with error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { incomeStatementData in
                XCTAssertNotNil(incomeStatementData.annualReports.first)
                XCTAssertEqual(incomeStatementData.symbol, "AAPL")
                XCTAssertEqual(incomeStatementData.annualReports.first?.netIncome, "57411000000")
                // You can add more assertions here based on your mock data
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }

    // Test handling of bad URLs
    func testFetchStockQuoteBadURL() {

        mockAPIService.mockStockQuoteResponse = nil
        
        let expectation = XCTestExpectation(description: "fetchStockQuote with bad URL completes")
        
        // Use the mock service to fetch the stock quote with a bad URL
        apiService.fetchStockQuote(forSymbol: "AAPL")
            .sink(receiveCompletion: { completion in
                if case .finished = completion {
                    XCTFail("Request should not succeed with a bad URL.")
                }
                expectation.fulfill()
            }, receiveValue: { _ in
                XCTFail("Request should not return a value with a bad URL.")
            })
            .store(in: &cancellables)
        
        // Wait for the expectation to be fulfilled, or time out after 1 second
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchStockQuoteUnauthorized() {
        
        // Simulate unauthorized access)
        mockAPIService.mockStockQuoteResponse = nil
        
        let expectation = XCTestExpectation(description: "fetchStockQuote with unauthorized access completes")
        
        // Execution: Use the mock service to fetch the stock quote with an invalid API key
        apiService.fetchStockQuote(forSymbol: "AAPL")
            .sink(receiveCompletion: { completion in
                if case .finished = completion {
                    XCTFail("Request should not succeed with unauthorized access.")
                }
                expectation.fulfill()
            }, receiveValue: { _ in
                XCTFail("Request should not return a value with unauthorized access.")
            })
            .store(in: &cancellables)
        
        // Wait for the expectation to be fulfilled, or time out after 1 second
        wait(for: [expectation], timeout: 1.0)
    }

    // Test error handling for bad stock symbol
    func testFetchStockQuoteErrorMessage() {
        // Setup: Set up a mock service with a failure response
        let expectedError = NSError(domain: "MockService", code: -1001, userInfo: nil)
        mockAPIService.mockStockQuoteResponse = Fail(error: expectedError).eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "fetchStockQuote with error message completes")
        
        // Execution: Use the mock service to fetch the stock quote
        apiService.fetchStockQuote(forSymbol: "AAPL")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error as NSError, expectedError, "Error should match expected error.")
                    expectation.fulfill()
                } else {
                    XCTFail("Request should fail with an error.")
                }
            }, receiveValue: { _ in
                XCTFail("Request should not return a value with an error.")
            })
            .store(in: &cancellables)
        
        // Wait for the expectation to be fulfilled, or time out after 1 second
        wait(for: [expectation], timeout: 1.0)
    }


}

