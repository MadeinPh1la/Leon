//
//  MockAPIService.swift
//  LeonTests
//
//  Created by Kevin Downey on 3/16/24.
//

import Combine
import Foundation
@testable import Leon

class MockAPIService: APIService {

    // Mock response publishers
    var mockStockQuoteResponse: AnyPublisher<StockQuoteResponse, Error>?
    var mockCompanyOverviewResponse: AnyPublisher<CompanyOverview, Error>?
    var mockCashFlowResponse: AnyPublisher<CashFlowResponse, Error>?
    var mockIncomeStatementResponse: AnyPublisher<IncomeStatementData, Error>?
    var mockBalanceSheetResponse: AnyPublisher<BalanceSheetData, Error>?
        
        init() {
            // Mock StockQuoteResponse
            let stockQuote = StockQuoteResponse(globalQuote: StockQuote(symbol: "AAPL", open: "150.00", high: "155.00", low: "149.00", price: "152.00", volume: "100000", latestTradingDay: "2023-03-16", previousClose: "150.00", change: "2.00", changePercent: "1.33%"))
            self.mockStockQuoteResponse = Just(stockQuote)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()

            // Mock CompanyOverview
            let companyOverview = CompanyOverview(symbol: "AAPL", name: "Apple Inc.", description: "Designs, manufactures, and markets mobile communication and media devices.", marketCapitalization: "2200000000000", sharesOutstanding: "17000000000")
            self.mockCompanyOverviewResponse = Just(companyOverview)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()

            // Mock CashFlowResponse
            let cashFlow = CashFlowResponse(symbol: "AAPL", annualReports: [AnnualCashFlowReport(fiscalDateEnding: "2020-09-30", reportedCurrency: "USD", operatingCashflow: "50000000", capitalExpenditures: "-10000000", netIncome: "40000000")])
            self.mockCashFlowResponse = Just(cashFlow)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()

            // Mock IncomeStatementData
            let incomeStatement = IncomeStatementData(symbol: "AAPL", annualReports: [AnnualIncomeStatementReport(fiscalDateEnding: "2020-09-30", reportedCurrency: "USD", grossProfit: "98000000000", totalRevenue: "260000000000", operatingIncome: "66288000000", netIncome: "57411000000", ebit: "55000000000")])
            self.mockIncomeStatementResponse = Just(incomeStatement)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()

            // Mock BalanceSheetData
            let balanceSheet = BalanceSheetData(symbol: "AAPL", annualReports: [AnnualBalanceSheetReport(fiscalDateEnding: "2020-09-30", reportedCurrency: "USD", totalAssets: "323000000000", totalCurrentAssets: "100000000000", cashAndCashEquivalentsAtCarryingValue: "143000000000", totalLiabilities: "38000000000", totalCurrentLiabilities: "105000000000", longTermDebt: "75000000000")])
            self.mockBalanceSheetResponse = Just(balanceSheet)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

    
    func fetchData<T: Decodable>(from url: URL, responseType: T.Type) -> AnyPublisher<T, Error> {
        fatalError("fetchData should not be called directly in the mock.")
    }

    
    func fetchStockQuote(forSymbol symbol: String) -> AnyPublisher<StockQuoteResponse, Error> {
        return mockStockQuoteResponse ?? Fail(error: NSError(domain: "MockService", code: -1001, userInfo: nil)).eraseToAnyPublisher()
    }

    func fetchCompanyOverview(forSymbol symbol: String) -> AnyPublisher<CompanyOverview, Error> {
        return mockCompanyOverviewResponse ?? Fail(error: NSError(domain: "MockService", code: -1002, userInfo: nil)).eraseToAnyPublisher()
    }

    func fetchCashFlowData(forSymbol symbol: String) -> AnyPublisher<CashFlowResponse, Error> {
        return mockCashFlowResponse ?? Fail(error: NSError(domain: "MockService", code: -1002, userInfo: nil)).eraseToAnyPublisher()
    }

    func fetchIncomeStatement(forSymbol symbol: String) -> AnyPublisher<IncomeStatementData, Error> {
        return mockIncomeStatementResponse ?? Fail(error: NSError(domain: "MockService", code: -1002, userInfo: nil)).eraseToAnyPublisher()
    }

    func fetchBalanceSheet(forSymbol symbol: String) -> AnyPublisher<BalanceSheetData, Error> {
        return mockBalanceSheetResponse ?? Fail(error: NSError(domain: "MockService", code: -1002, userInfo: nil)).eraseToAnyPublisher()
    }
}
