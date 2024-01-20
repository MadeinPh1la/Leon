//
//  API.swift
//  Leon
//
//  Created by Kevin Downey on 1/19/24.
//

import Foundation

class API {
    static let shared = API()
    private let apiKey = "ZJ2EBFQVPOYC3HT0"
    
    // Fetch income statements
    //    func fetchIncomeStatements(forSymbol symbol: String, completion: @escaping (Result<[IncomeStatement], Error>) -> Void) {
    //           let url = URL(string: "https://www.alphavantage.co/query?function=INCOME_STATEMENT&symbol=\(symbol)&apikey=\(apiKey)")!
    //           // Implementation for fetching income statements...
    //       }
    
    func fetchIncomeStatements(forSymbol symbol: String, completion: @escaping (Result<IncomeStatementResponse, Error>) -> Void) {
        let urlString = "https://www.alphavantage.co/query?function=INCOME_STATEMENT&symbol=\(symbol)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let response = try JSONDecoder().decode(IncomeStatementResponse.self, from: data)
                completion(.success(response))
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }

    
}

//       // Fetch balance sheets
//       func fetchBalanceSheets(forSymbol symbol: String, completion: @escaping (Result<[BalanceSheet], Error>) -> Void) {
//           let url = URL(string: "https://www.alphavantage.co/query?function=BALANCE_SHEET&symbol=\(symbol)&apikey=\(apiKey)")!
//           // Implementation for fetching balance sheets...
//       }
//    
//    // Fetch economic indicators
//       func fetchEconomicIndicators(forSymbol symbol: String, completion: @escaping (Result<EconomicIndicatorsResponse, Error>) -> Void) {
//           let url = URL(string: "https://www.alphavantage.co/query?function=ECONOMIC_INDICATOR&symbol=\(symbol)&apikey=\(apiKey)")!
//           // Implementation for fetching economic indicators...
//       }
//
//    // Fetch Cash Flow Statements
//    func fetchCashFlowStatements(completion: @escaping (Result<[CashFlowStatement], Error>) -> Void) {
//        let urlString = "https://www.alphavantage.co/query?function=CASH_FLOW&apikey=\(apiKey)"
//        fetchData(urlString: urlString, completion: completion)
//    }
//
//    // Generic method to fetch data
//    private func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
//        guard let url = URL(string: urlString) else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//
//            do {
//                let decodedData = try JSONDecoder().decode(T.self, from: data)
//                completion(.success(decodedData))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//
//    // Add methods for fetching economic indicators...
//}
//private func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
//    guard let url = URL(string: urlString) else {
//        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//        return
//    }
//    print("Fetching data from URL: \(url)")
//
//    URLSession.shared.dataTask(with: url) { data, response, error in
//        if let error = error {
//            print("Network error: \(error.localizedDescription)")
//            completion(.failure(error))
//            return
//        }
//
//        guard let data = data else {
//            print("No data received")
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//            return
//        }
//
//        do {
//            let decodedData = try JSONDecoder().decode(T.self, from: data)
//            print("Data fetched successfully: \(decodedData)")
//            completion(.success(decodedData))
//        } catch {
//            print("Error decoding data: \(error.localizedDescription)")
//            completion(.failure(error))
//        }
//    }.resume()


