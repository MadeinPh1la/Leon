//
//  API.swift
//  Leon
//
//  Created by Kevin Downey on 1/19/24.
//

import Foundation

// Structs to decode the JSON response

struct StockQuoteResponse: Decodable {
    let globalQuote: StockQuote

    enum CodingKeys: String, CodingKey {
        case globalQuote = "Global Quote"
    }
}

struct StockQuote: Decodable {
    let symbol: String
    let open: String?
    let high: String?
    let low: String?
    let price: String?
    let volume: String?
    let latestTradingDay: String?
    let previousClose: String?
    let change: String?
    let changePercent: String?
    
    enum CodingKeys: String, CodingKey {
        case symbol = "01. symbol"
        case open = "02. open"
        case high = "03. high"
        case low = "04. low"
        case price = "05. price"
        case volume = "06. volume"
        case latestTradingDay = "07. latest trading day"
        case previousClose = "08. previous close"
        case change = "09. change"
        case changePercent = "10. change percent"
    }
}

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

//Protocol for URLSessionDataTask's resume() method to mock test it.
protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}


class API {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    
    static let shared = API()
    private let apiKey = "EEU03VBW3KPPRD7O"
    
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
    }
    


