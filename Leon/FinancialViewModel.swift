//
//  FinancialViewModel.swift
//  Leon
//
//  Created by Kevin Downey on 1/19/24.
//

import Foundation
import Combine

class FinancialViewModel: ObservableObject {
    @Published var stockQuote: StockQuote?
    @Published var errorMessage: String?
    
    //Fetch stock quotes
    func fetchStockQuote(forSymbol symbol: String) {
        
           API.shared.fetchStockQuote(forSymbol: symbol) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let quote):
                       print("Fetched quote: \(quote)")
                       self?.stockQuote = quote
                   case .failure(let error):
                       print("Error fetching stock quote: \(error.localizedDescription)")
                       self?.errorMessage = "Error fetching data"
                   }
               }
           }
       }
   }
