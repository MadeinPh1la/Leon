//
//  FinancialModel.swift
//  Leon
//
//  Created by Kevin Downey on 1/18/24.
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

struct FinancialMetrics: Decodable {
    let ebit: Double?
    let taxRate: Double?
    let capEx: Double?
    let workingCapitalChange: Double?
    let discountRate: Double?
    let perpetualGrowthRate: Double?

}

struct CompanyOverview: Codable {
    var symbol: String
    var companyName: String
    var description: String
    
    // Parsing Alphavantage API json
    enum CodingKeys: String, CodingKey {
           case symbol = "Symbol"
           case companyName = "CompanyName"
           case description = "Description"
       }
    }




