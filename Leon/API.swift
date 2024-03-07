//
//  API.swift
//  Leon
//
//  Created by Kevin Downey on 1/19/24.
//

import Foundation
import Combine

class API: FinancialDataService {
    
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    
    static let shared = API()
    private let apiKey = "EEU03VBW3KPPRD7O"
    
    
    // Function to fetch stock quote data for a given symbol
    func fetchStockQuote(forSymbol symbol: String, completion: @escaping (Result<StockQuote, Error>) -> Void) {
        guard let url = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(symbol)&apikey=\(apiKey)") else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Error fetching stock quote: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
                print("No data received")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(StockQuoteResponse.self, from: data)
                completion(.success(decodedResponse.globalQuote))
                print("Quote fetched successfully: \(decodedResponse)")
            } catch {
                completion(.failure(error))
                print("Decoding error: \(error.localizedDescription)")
                
            }
        }.resume()
    }
    
    
    // Method to fetch company overview
    
    func fetchCompanyOverview(forSymbol symbol: String, completion: @escaping (Result<CompanyOverview, Error>) -> Void) {
        guard let url = URL(string: "https://www.alphavantage.co/query?function=OVERVIEW&symbol=\(symbol)&apikey=\(apiKey)") else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("CompanyOverview: Error fetching stock quote: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
                print("CompanyOverview: No data received")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(CompanyOverview.self, from: data)
                completion(.success(decodedResponse))
                print("CO:Quote fetched successfully: \(decodedResponse)")
            } catch {
                completion(.failure(error))
                print("Decoding error: \(error.localizedDescription)")
                
            }
        }
        task.resume()
    }
    
    func fetchDCFData(forSymbol symbol: String, completion: @escaping (Result<DCFModel, Error>) -> Void) {
        
        guard let url = URL(string: "https://www.alphavantage.co/query?function=OVERVIEW&symbol=\(symbol)&apikey=\(apiKey)") else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("DCF: Error fetching DCF data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
                print("CompanyOverview: No data received")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(DCFModel.self, from: data)
                completion(.success(decodedResponse))
                print("DCF:Quote fetched successfully: \(decodedResponse)")
            } catch {
                completion(.failure(error))
                print("Decoding error: \(error.localizedDescription)")
                
            }
            
            
        }
    }
}
