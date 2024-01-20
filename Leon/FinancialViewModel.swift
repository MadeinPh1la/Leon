//
//  FinancialViewModel.swift
//  Leon
//
//  Created by Kevin Downey on 1/19/24.
//

import Foundation
import Combine

class FinancialViewModel: ObservableObject {
    @Published var financialModel: FinancialModel?
    @Published var economicData: EconomicIndicatorsResponse?
    @Published var error: String?
    @Published var errorMessage: String? // Used to display error messages in the UI
    @Published var incomeStatements: [IncomeStatement] = []

    
    func fetchIncomeStatements(forSymbol symbol: String) {
            API.shared.fetchIncomeStatements(forSymbol: symbol) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let incomeStatementResponse):
                        self?.incomeStatements = incomeStatementResponse.annualReports
                        self?.errorMessage = nil // Clear any previous error message
                    case .failure(let error):
                        print("Error fetching income statements: \(error.localizedDescription)")
                        self?.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                        // Optionally, implement retry logic or other fallback here
                    }
                }
            }
        }
    }
    // Fetch and store Income Statements
//    func fetchIncomeStatements(completion: @escaping (Result<[IncomeStatement], Error>) -> Void) {
//        API.shared.fetchIncomeStatements { result in
//            switch result {
//            case .success(let incomeStatements):
//                self.financialModel?.incomeStatements = incomeStatements
//                completion(.success(incomeStatements))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
