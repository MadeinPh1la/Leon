//
//  FinancialViewModel.swift
//  Leon
//
//  Created by Kevin Downey on 1/19/24.
//

import FirebaseAuth
import Foundation
import Combine

class FinancialViewModel: ObservableObject {
    @Published var quote: StockQuote?
    @Published var stockQuoteState: DataState = .idle
    @Published var errorMessage: String?
    @Published var companyOverview: CompanyOverview?
    @Published var dcfValue: Double?

    
    private var cancellables = Set<AnyCancellable>()
    private let api: API
    
    init(api: API = API.shared) {
        self.api = api
    }
    
    enum DataState {
        case idle, loading, loaded, error(String)
    }
    
    // Fetch stock quote
    func fetchStockQuote(forSymbol symbol: String) {
        stockQuoteState = .loading
        api.fetchStockQuote(forSymbol: symbol) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let quote):
                    self?.quote = quote
                    self?.stockQuoteState = .loaded
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch quote: \(error.localizedDescription)"
                    self?.stockQuoteState = .error(error.localizedDescription)
                }
            }
        }
    }
    
    // Fetch company overview data
    func fetchCompanyOverview(forSymbol symbol: String) {
        api.fetchCompanyOverview(forSymbol: symbol) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let overview):
                    self?.companyOverview = overview
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch company overview: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func loadDCFValue(forSymbol symbol: String) {
        api.fetchDCFData(forSymbol: symbol) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let financialData):
                        let dcfValue = self?.dcfModel.calculateDCF(data: financialData)
                        self?.dcfValue = dcfValue
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
}
