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

struct AnnualReport: Codable {
    let operatingCashFlow: String
    let capitalExpenditures: String
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

struct CashFlowReport: Codable {
    let fiscalDateEnding: String
    let reportedCurrency: String
    let capitalExpenditures: String
}

struct CashFlowStatement: Decodable {
    let annualReports: [AnnualReport]
}

struct CashFlowData: Decodable {
    let freeCashFlow: Double?
}

struct CashFlowResponse: Decodable {
    var symbol: String
    var annualReports: [AnnualCashFlowReport]
}

struct AnnualCashFlowReport: Decodable {
    var fiscalDateEnding: String
    var reportedCurrency: String
    var operatingCashflow: String
    var capitalExpenditures: String
    var netIncome: String

    // Computed property to calculate free cash flow
    var freeCashFlow: Double {
        if let operatingCashFlowDouble = Double(operatingCashflow),
           let capitalExpendituresDouble = Double(capitalExpenditures) {
            return operatingCashFlowDouble - capitalExpendituresDouble
        }
        return 0.0  // Or handle this scenario as appropriate
    }
}

struct IncomeStatementResponse: Decodable {
    let symbol: String
    let annualReports: [AnnualIncomeStatementReport]
}

struct BalanceSheetResponse: Codable {
    let symbol: String
    let annualReports: [AnnualBalanceSheetReport]
}

struct AnnualBalanceSheetReport: Codable {
    let fiscalDateEnding: String
    let reportedCurrency: String
    let totalAssets: String
    let totalCurrentAssets: String
    let cashAndCashEquivalentsAtCarryingValue: String
    let totalLiabilities: String
    let totalCurrentLiabilities: String
    let longTermDebt: String
}

struct AnnualIncomeStatementReport: Codable {
    let fiscalDateEnding: String
    let reportedCurrency: String
    let grossProfit: String
    let totalRevenue: String
    let operatingIncome: String
    let netIncome: String
    let ebit: String
}

struct IncomeStatementData: Codable {
    let symbol: String
    let annualReports: [AnnualIncomeStatementReport]
}


struct BalanceSheetData: Codable {
    let symbol: String
    let annualReports: [AnnualBalanceSheetReport]
}

