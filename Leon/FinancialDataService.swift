//
//  FinancialDataService.swift
//  Leon
//
//  Created by Kevin Downey on 2/18/24.
//

import Foundation

protocol FinancialDataService {
    func fetchStockQuote(forSymbol symbol: String, completion: @escaping (Result<StockQuote, Error>) -> Void)
    func fetchCompanyOverview(forSymbol symbol: String, completion: @escaping (Result<CompanyOverview, Error>) -> Void)

}
