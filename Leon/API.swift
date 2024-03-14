//
//  API.swift
//  Leon
//
//  Created by Kevin Downey on 1/19/24.
//

import Foundation
import Combine

class API {
    
    static let shared = API()
    private let apiKey = "EEU03VBW3KPPRD7O"
    private let networkService: NetworkService
    
    init(networkService: NetworkService = URLSession.shared) {
        self.networkService = networkService
    }
    
    // Fetch stock quote using Combine
    func fetchStockQuote(forSymbol symbol: String) -> AnyPublisher<StockQuoteResponse, Error> {
        guard let url = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(symbol)&apikey=\(apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return networkService.fetchData(from: url, responseType: StockQuoteResponse.self)
    }
    
    // Fetch data for company overview using Combine
    func fetchCompanyOverview(forSymbol symbol: String) -> AnyPublisher<CompanyOverview, Error> {
        guard let url = URL(string: "https://www.alphavantage.co/query?function=OVERVIEW&symbol=\(symbol)&apikey=\(apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return networkService.fetchData(from: url, responseType: CompanyOverview.self)
    }
    
    // Fetch Cash Flow data using Combine
    func fetchCashFlowData(forSymbol symbol: String) -> AnyPublisher<CashFlowResponse, Error> {
        let urlString = "https://www.alphavantage.co/query?function=CASH_FLOW&symbol=\(symbol)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return networkService.fetchData(from: url, responseType: CashFlowResponse.self)
    }
    
    // Fetch additional data points from company's Income Statement for DCF calculation
    func fetchIncomeStatement(forSymbol symbol: String) -> AnyPublisher<IncomeStatementData, Error> {
        let urlString = "https://www.alphavantage.co/query?function=INCOME_STATEMENT&symbol=\(symbol)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return networkService.fetchData(from: url, responseType: IncomeStatementData.self)
    }
    
    // Fetch additional data points from company's Balance Sheet for an even more complete DCF calculation
    func fetchBalanceSheet(forSymbol symbol: String) -> AnyPublisher<BalanceSheetData, Error> {
        let urlString = "https://www.alphavantage.co/query?function=BALANCE_SHEET&symbol=\(symbol)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return networkService.fetchData(from: url, responseType: BalanceSheetData.self)
    }
}
