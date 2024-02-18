//
//  API.swift
//  Leon
//
//  Created by Kevin Downey on 1/19/24.
//

import Foundation

class API: FinancialDataService {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    
    static let shared = API()
    private let apiKey = "EEU03VBW3KPPRD7O"
    
    
    // Get the Company Overview description
    func fetchCompanyOverview(forSymbol symbol: String, completion: @escaping (Result<CompanyOverview, Error>) -> Void) {
        let urlString = "https://api.example.com/overview?symbol=\(symbol)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
    }
        
        
        // Function to fetch stock quote data for a given symbol
        func fetchStockQuote(forSymbol symbol: String, completion: @escaping (Result<StockQuote, Error>) -> Void) {
            guard let url = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(symbol)&apikey=\(apiKey)") else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            
            let task = session.dataTask(with: url) { data, response, error in
                // Your handling code
            }
            task.resume()
            
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(StockQuoteResponse.self, from: data)
                    completion(.success(decodedResponse.globalQuote))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
        
        
        
        //Fetch Cash Flow Metrics
        func fetchFinancialMetrics(forSymbol symbol: String, completion: @escaping (Result<FinancialMetrics, Error>) -> Void) {
            
            guard let url = URL(string: "https://www.alphavantage.co/query?function=Cash_Flow&symbol=\(symbol)&apikey=\(apiKey)") else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                    return
                }
                
                do {
                    let decodedMetrics = try JSONDecoder().decode(FinancialMetrics.self, from: data)
                    completion(.success(decodedMetrics))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
        // Fetch Company Overview Details
        
        func fetchCompanyOverview(symbol: String, completion: @escaping (Result<FinancialMetrics, Error>) -> Void) {
            guard let url =  URL(string: "https://www.alphavantage.co/query?function=OVERVIEW&symbol=\(symbol)&apikey=\(apiKey)") else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                    return
                }
                
                do {
                    let decodedMetrics = try JSONDecoder().decode(FinancialMetrics.self, from: data)
                    completion(.success(decodedMetrics))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
    }
