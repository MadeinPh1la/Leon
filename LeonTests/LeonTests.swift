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
    private var api: API!
    private var mockNetworkService: MockNetworkService!

    override func setUp() {
           super.setUp()
           cancellables = Set<AnyCancellable>()
           mockNetworkService = MockNetworkService()
           api = API(networkService: mockNetworkService)
       }
    
    override func tearDown() {
            cancellables = nil
            mockNetworkService = nil
            api = nil
            super.tearDown()
        }
    
    func testFetchStockQuoteSuccess() {
        let jsonString = """
        {
            "Global Quote": {
                "01. symbol": "AAPL",
                "05. price": "154.00"
            }
        }
        """
        mockNetworkService.mockResponse = jsonString.data(using: .utf8)

        let expectation = XCTestExpectation(description: "fetchStockQuote completes")
        
        api.fetchStockQuote(forSymbol: "AAPL")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Request failed with error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { stockQuoteResponse in
                XCTAssertEqual(stockQuoteResponse.globalQuote.symbol, "AAPL")
                XCTAssertEqual(stockQuoteResponse.globalQuote.price, "154.00")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }

    // Test fetching data for Company Overview
    
    func testFetchCompanyOverviewSuccess() {
        let jsonString = """
        {
            "Symbol": "AAPL",
            "Name": "Apple Inc.",
            "Description": "Apple Inc. designs, manufactures, and markets mobile communication and media devices."
        }
        """
        mockNetworkService.mockResponse = jsonString.data(using: .utf8)
        
        let expectation = XCTestExpectation(description: "fetchCompanyOverview completes")
        
        api.fetchCompanyOverview(forSymbol: "AAPL")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
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
        let jsonString = """
        {
            "symbol": "AAPL",
            "annualReports": [
                {
                    "fiscalDateEnding": "2020-09-30",
                    "reportedCurrency": "USD",
                    "operatingCashflow": "100000000",
                    "capitalExpenditures": "-50000000",
                    "netIncome": "40000000"
                }
            ]
        }
        """
        mockNetworkService.mockResponse = jsonString.data(using: .utf8)
        
        let expectation = XCTestExpectation(description: "fetchCashFlowData completes")
        
        api.fetchCashFlowData(forSymbol: "AAPL")
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
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // Test fetching Income Statement data
    
    func testFetchIncomeStatementSuccess() {
        let jsonString = """
        {
            "symbol": "AAPL",
            "annualReports": [
                {
                    "fiscalDateEnding": "2020-09-30",
                    "reportedCurrency": "USD",
                    "totalRevenue": "274515000000",
                    "grossProfit": "104956000000",
                    "operatingIncome": "66288000000",
                    "netIncome": "57411000000"
                }
            ]
        }
        """
        mockNetworkService.mockResponse = jsonString.data(using: .utf8)
        
        let expectation = XCTestExpectation(description: "fetchIncomeStatement completes")
        
        api.fetchIncomeStatement(forSymbol: "AAPL")
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
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }


}

