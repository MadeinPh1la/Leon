//
//  FinancialModel.swift
//  Leon
//
//  Created by Kevin Downey on 1/18/24.
//

import Foundation


struct IncomeStatementResponse: Decodable {
    var symbol: String
    var annualReports: [IncomeStatement]
    var quarterlyReports: [IncomeStatement]
}

struct IncomeStatement: Decodable {
    var fiscalDateEnding: String
    var reportedCurrency: String
    var grossProfit: String
    var totalRevenue: String
    var costOfRevenue: String
    // ... other fields as needed ...
    var netIncome: String
}


// Struct for Balance Sheet
struct BalanceSheet: Decodable {
    var fiscalDateEnding: String
    var totalAssets: String
    var totalLiabilities: String
    var totalEquity: String
    // ... other fields as needed
}

// Struct for Cash Flow Statement
struct CashFlowStatement: Decodable {
    var fiscalDateEnding: String
    var operatingCashflow: String
    var capitalExpenditures: String
    // ... other fields as needed
}

// Struct for Economic Indicator
struct EconomicIndicator: Decodable {
    var date: String
    var value: String
}

// Struct to model the response for economic indicators
struct EconomicIndicatorsResponse: Decodable {
    var name: String
    var interval: String
    var unit: String
    var data: [EconomicDataPoint]
}

struct EconomicDataPoint: Decodable {
    var date: String
    var value: String
}

// Main FinancialModel class
class FinancialModel {
    var incomeStatements: [IncomeStatement]?
    var balanceSheets: [BalanceSheet]?
    var cashFlowStatements: [CashFlowStatement]?
    var economicIndicators: [EconomicIndicator]?

    // Calculate Net Profit Margin
    func calculateNetProfitMargin(forYear year: String) -> Double? {
        guard let incomeStatement = incomeStatements?.first(where: { $0.fiscalDateEnding.starts(with: year) }) else {
            return nil
        }

        if let netIncome = Double(incomeStatement.netIncome),
           let totalRevenue = Double(incomeStatement.totalRevenue) {
            return (netIncome / totalRevenue) * 100
        } else {
            return nil
        }
    }


    // Calculate Current Ratio
    func calculateCurrentRatio(forYear year: String) -> Double? {
        guard let balanceSheet = balanceSheets?.first(where: { $0.fiscalDateEnding.starts(with: year) }),
              let totalAssets = Double(balanceSheet.totalAssets),
              let totalLiabilities = Double(balanceSheet.totalLiabilities) else {
            return nil
        }
        return totalAssets / totalLiabilities
    }


    // Calculate Return on Equity (ROE)
    func calculateReturnOnEquity(forYear year: String) -> Double? {
        guard let incomeStatement = incomeStatements?.first(where: { $0.fiscalDateEnding.starts(with: year) }),
              let balanceSheet = balanceSheets?.first(where: { $0.fiscalDateEnding.starts(with: year) }),
              let netIncome = Double(incomeStatement.netIncome),
              let totalEquity = Double(balanceSheet.totalEquity) else {
            return nil
        }
        return (netIncome / totalEquity) * 100
    }

    // Calculate Debt-to-Equity Ratio
    func calculateDebtToEquityRatio(forYear year: String) -> Double? {
        guard let balanceSheet = balanceSheets?.first(where: { $0.fiscalDateEnding.starts(with: year) }),
              let totalLiabilities = Double(balanceSheet.totalLiabilities),
              let totalEquity = Double(balanceSheet.totalEquity) else {
            return nil
        }
        return totalLiabilities / totalEquity
    }

    // Calculate Economic Growth Rate
    func calculateEconomicGrowthRate() -> [Double] {
        var growthRates = [Double]()
        for i in 0..<(economicIndicators?.count ?? 1) - 1 {
            if let currentYearValueString = economicIndicators?[i].value,
               let previousYearValueString = economicIndicators?[i + 1].value,
               let currentYearValue = Double(currentYearValueString),
               let previousYearValue = Double(previousYearValueString) {
                let growthRate = ((currentYearValue - previousYearValue) / previousYearValue) * 100
                growthRates.append(growthRate)
            }
        }
        return growthRates
    }

    // ... Additional methods and calculations
}
