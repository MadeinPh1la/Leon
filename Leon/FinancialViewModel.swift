//
//  FinancialViewModel.swift
//  Leon
//
//  Created by Kevin Downey on 1/19/24.
//

import FirebaseAuth
import Foundation
import Combine

// Financial Data Management
class FinancialViewModel: ObservableObject {
    private var financialDataService: FinancialDataService
    @Published var companyOverview: CompanyOverview?
    @Published var quote: StockQuote?
    @Published var dcfResult: Double? 
    @Published var stockQuoteState: DataState<StockQuote> = .idle
    @Published var errorMessage: String?

    
    init(financialDataService: FinancialDataService = API.shared) {
        self.financialDataService = financialDataService
    }
    
    enum DataState<T> {
        case idle
        case loading
        case loaded(T)
        case error(String)
    }
    
    func fetchStockQuote(forSymbol symbol: String) {
        print("Fetching stock quote for symbol: \(symbol)")
        stockQuoteState = .loading
        financialDataService.fetchStockQuote(forSymbol: symbol) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let quote):
                    self?.stockQuoteState = .loaded(quote)
                case .failure(let error):
                    self?.stockQuoteState = .error("Error fetching stock quote: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func calculateDCF(from metrics: FinancialMetrics) -> Double {
        guard let ebit = metrics.ebit,
              let taxRate = metrics.taxRate,
              let capEx = metrics.capEx,
              let workingCapitalChange = metrics.workingCapitalChange,
              let discountRate = metrics.discountRate,
              let perpetualGrowthRate = metrics.perpetualGrowthRate else { return 0 }
        
        let fcff = ebit * (1 - taxRate) - capEx - workingCapitalChange
        let dcfValue = fcff / (discountRate - perpetualGrowthRate)
        return dcfValue
    }
}
