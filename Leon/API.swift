//
//  API.swift
//  Leon
//
//  Created by Kevin Downey on 1/19/24.
//

import Foundation
import Combine

class API: APIService {
    static let shared = API()
    private let apiKey = "EEU03VBW3KPPRD7O"
    
    private init() {} // Singleton to prevent multiple instances
    
    // Implementation of fetchData adhering to APIService
    func fetchData<T: Decodable>(from url: URL, responseType: T.Type) -> AnyPublisher<T, Error> {
           URLSession.shared.dataTaskPublisher(for: url)
               .map(\.data)
               .decode(type: T.self, decoder: JSONDecoder())
               .mapError { $0 as Error }
               .eraseToAnyPublisher()
       }

    // Fetch stock quote using Combine
    func fetchStockQuote(forSymbol symbol: String) -> AnyPublisher<StockQuoteResponse, Error> {
         guard let url = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(symbol)&apikey=\(apiKey)") else {
             return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
         }
        return fetchData(from: url, responseType: StockQuoteResponse.self)
     }
    
    // Fetch data for company overview using Combine
    func fetchCompanyOverview(forSymbol symbol: String) -> AnyPublisher<CompanyOverview, Error> {
        guard let url = URL(string: "https://www.alphavantage.co/query?function=OVERVIEW&symbol=\(symbol)&apikey=\(apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return fetchData(from: url, responseType: CompanyOverview.self)
    }
    
    // Fetch Cash Flow data using Combine
    public func fetchCashFlowData(forSymbol symbol: String) -> AnyPublisher<CashFlowResponse, Error> {
        let urlString = "https://www.alphavantage.co/query?function=CASH_FLOW&symbol=\(symbol)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return fetchData(from: url, responseType: CashFlowResponse.self)
    }
    
    // Fetch additional data points from company's Income Statement for DCF calculation
    public func fetchIncomeStatement(forSymbol symbol: String) -> AnyPublisher<IncomeStatementData, Error> {
        let urlString = "https://www.alphavantage.co/query?function=INCOME_STATEMENT&symbol=\(symbol)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return fetchData(from: url, responseType: IncomeStatementData.self)
    }
    
    // Fetch additional data points from company's Balance Sheet for an even more complete DCF calculation
    public func fetchBalanceSheet(forSymbol symbol: String) -> AnyPublisher<BalanceSheetData, Error> {
        let urlString = "https://www.alphavantage.co/query?function=BALANCE_SHEET&symbol=\(symbol)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return fetchData(from: url, responseType: BalanceSheetData.self)
    }
    
    // Fetch news
    func fetchNewsFeed(forSymbol symbol: String) -> AnyPublisher<NewsFeed, Error> {
        let urlString = "https://www.alphavantage.co/query?function=NEWS_SENTIMENT&symbol=\(symbol)&apikey=\(apiKey)"

        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: NewsFeed.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
