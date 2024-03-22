//
//  FinancialModel.swift
//  Leon
//
//  Created by Kevin Downey on 1/18/24.
//

import Foundation

// Structs to decode the JSON response

public struct StockQuoteResponse: Decodable {
    public let globalQuote: StockQuote

    enum CodingKeys: String, CodingKey {
        case globalQuote = "Global Quote"
    }
}

// Stock quote data
public struct StockQuote: Decodable {
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


public struct CompanyOverview: Codable {
    var symbol: String
    var name: String
    var description: String
    var marketCapitalization: String?
    var sharesOutstanding: String? 


    
    // Parsing AlphaVantage API json
    enum CodingKeys: String, CodingKey {
        case symbol = "Symbol"
        case name = "Name"
        case description = "Description"
        case marketCapitalization = "MarketCapitalization"
        case sharesOutstanding = "SharesOutstanding"
    }
}

public struct AnnualReport: Codable {
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

public struct IncomeStatement: Codable {
    let ebit: Double
    let taxRate: Double
}

public struct CashFlowReport: Codable {
    let fiscalDateEnding: String
    let reportedCurrency: String
    let capitalExpenditures: String
}

public struct CashFlowStatement: Decodable {
    let annualReports: [AnnualReport]
}

public struct CashFlowData: Decodable {
    let freeCashFlow: Double?
}

public struct CashFlowResponse: Decodable {
    var symbol: String
    var annualReports: [AnnualCashFlowReport]
}

public struct AnnualCashFlowReport: Decodable {
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

public struct IncomeStatementResponse: Decodable {
    let symbol: String
    let annualReports: [AnnualIncomeStatementReport]
}

public struct BalanceSheetResponse: Codable {
    let symbol: String
    let annualReports: [AnnualBalanceSheetReport]
}

public struct AnnualBalanceSheetReport: Codable {
    let fiscalDateEnding: String
    let reportedCurrency: String
    let totalAssets: String
    let totalCurrentAssets: String
    let cashAndCashEquivalentsAtCarryingValue: String
    let totalLiabilities: String
    let totalCurrentLiabilities: String
    let longTermDebt: String
}

public struct AnnualIncomeStatementReport: Codable {
    let fiscalDateEnding: String
    let reportedCurrency: String
    let grossProfit: String
    let totalRevenue: String
    let operatingIncome: String
    let netIncome: String
    let ebit: String
}

public struct IncomeStatementData: Codable {
    let symbol: String
    let annualReports: [AnnualIncomeStatementReport]
}


public struct BalanceSheetData: Codable {
    let symbol: String
    let annualReports: [AnnualBalanceSheetReport]
}

struct NewsFeed: Decodable {
    let items: String
    let feed: [NewsArticle]
}

struct NewsArticle: Identifiable, Decodable, Hashable {
    let id = UUID()
    let banner_image: String
    let title: String
    let url: String
    let time_published: String
    let summary: String

    private enum CodingKeys: String, CodingKey {
        case banner_image, title, url, time_published, summary
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decode other properties as usual
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(String.self, forKey: .url)
        self.time_published = try container.decode(String.self, forKey: .time_published)
        self.summary = try container.decode(String.self, forKey: .summary)
        // Provide a default value for `banner_image` if missing
        self.banner_image = try container.decodeIfPresent(String.self, forKey: .banner_image) ?? "Default_Image_URL"
    }
}

struct TrendingResponse: Decodable {
    let metadata: String
    let lastUpdated: String
    let topGainers: [Stock]
    let topLosers: [Stock]

    
    enum CodingKeys: String, CodingKey {
        case metadata
        case lastUpdated = "last_updated"
        case topGainers = "top_gainers"
        case topLosers = "top_losers"
    }
}

struct Stock: Identifiable, Decodable, Hashable {
    let id = UUID()
    let ticker: String
    let price: String
    let changeAmount: String
    let changePercentage: String
    let volume: String

    enum CodingKeys: String, CodingKey {
        case ticker
        case price
        case changeAmount = "change_amount"
        case changePercentage = "change_percentage"
        case volume
    }
}
