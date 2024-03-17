//
//  MockAPI.swift
//  LeonTests
//
//  Created by Kevin Downey on 3/14/24.
//

import XCTest

import Combine
import Foundation
@testable import Leon

class MockAPI: APIService {
    var mockStockQuoteResponse: AnyPublisher<StockQuoteResponse, Error>?
    var mockCompanyOverviewResponse: AnyPublisher<CompanyOverview, Error>?
    var mockCashFlowResponse: AnyPublisher<CashFlowResponse, Error>?
    var mockIncomeStatementResponse: AnyPublisher<IncomeStatementData, Error>?
    var mockBalanceSheetResponse: AnyPublisher<BalanceSheetData, Error>?
    

    func fetchData<T: Decodable>(from url: URL, responseType: T.Type) -> AnyPublisher<T, Error> {
        fatalError("Direct call to fetchData(from:responseType:) is not supported in MockAPI.")
    }
    
    func fetchStockQuote(forSymbol symbol: String) -> AnyPublisher<StockQuoteResponse, Error> {
        return mockStockQuoteResponse ?? Fail(error: URLError(.unsupportedURL)).eraseToAnyPublisher()
    }

    func fetchCompanyOverview(forSymbol symbol: String) -> AnyPublisher<CompanyOverview, Error> {
        return mockCompanyOverviewResponse ?? Fail(error: URLError(.unsupportedURL)).eraseToAnyPublisher()
    }
    
    func fetchCashFlowData(forSymbol symbol: String) -> AnyPublisher<CashFlowResponse, Error> {
        return mockCashFlowResponse ?? Fail(error: URLError(.unsupportedURL)).eraseToAnyPublisher()
    }

    func fetchIncomeStatement(forSymbol symbol: String) -> AnyPublisher<IncomeStatementData, Error> {
        return mockIncomeStatementResponse ?? Fail(error: URLError(.unsupportedURL)).eraseToAnyPublisher()
    }

    func fetchBalanceSheet(forSymbol symbol: String) -> AnyPublisher<BalanceSheetData, Error> {
        return mockBalanceSheetResponse ?? Fail(error: URLError(.unsupportedURL)).eraseToAnyPublisher()
    }


}
