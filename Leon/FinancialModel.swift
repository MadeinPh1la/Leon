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

// Stock quote data
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
    var priceDouble: Double? {
        return Double(price ?? "")
    }
    
    // Parsing Alphavantage API json
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


struct CompanyOverview: Codable {
    var symbol: String
    var companyName: String
    var description: String
    
    // Parsing Alphavantage API json
    enum CodingKeys: String, CodingKey {
           case symbol = "Symbol"
           case companyName = "Name"
           case description = "Description"
       }
    }

struct IncomeStatementResponse: Codable {
    let annualReports: [AnnualReport]
}

struct AnnualReport: Codable {
    let fiscalDateEnding: String
    let reportedCurrency: String
    let grossProfit: String
    let totalRevenue: String
    let ebit: String
    let incomeTaxExpense: String // Needed for tax rate calculation
    let preTaxIncome: String // Needed for tax rate calculation
}

struct IncomeStatement: Codable {
    let ebit: Double
    let taxRate: Double
}

struct CashFlowResponse: Codable {
    let annualReports: [CashFlowReport]
}

struct CashFlowReport: Codable {
    let fiscalDateEnding: String
    let reportedCurrency: String
    let capitalExpenditures: String
}

