//
//  FinancialDataService.swift
//  Leon
//
//  Created by Kevin Downey on 2/18/24.
//

import Foundation
import Combine

struct SearchResults: Codable {
    var results: [SearchResult]
}

struct SearchResult: Codable {
    var symbol: String
    var name: String
}

// Define the protocol as before, but without default implementations.
protocol FinancialDataService {
    func fetchStockQuote(forSymbol symbol: String, completion: @escaping (Result<StockQuote, Error>) -> Void)
//    func fetchCompanyOverview(forSymbol symbol: String, completion: @escaping (Result<CompanyOverview, Error>) -> Void)
//    func fetchSymbolsPublisher(keyword: String) -> AnyPublisher<SearchResults, Error>
}

