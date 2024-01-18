//
//  FinancialModel.swift
//  Leon
//
//  Created by Kevin Downey on 1/18/24.
//

import Foundation

// MARK: - Financial Statement Structure
struct FinancialStatement {
    var year: Int
    var revenue: Double
    var expenses: Double
    var netIncome: Double
    var operatingCashFlow: Double
    var assets: Double
    var liabilities: Double
    var equity: Double
}

// MARK: - Financial Analysis Class
class FinancialAnalysis {
    var statements: [FinancialStatement]

    init(statements: [FinancialStatement]) {
        self.statements = statements
    }

    func calculateProfitMargins() -> [Int: Double] {
        var margins = [Int: Double]()
        for statement in statements {
            let margin = statement.netIncome / statement.revenue
            margins[statement.year] = margin
        }
        return margins
    }

    func calculateDebtToEquityRatio() -> [Int: Double] {
        var ratios = [Int: Double]()
        for statement in statements {
            let ratio = statement.liabilities / statement.equity
            ratios[statement.year] = ratio
        }
        return ratios
    }
    
    // Additional methods for other financial metrics
}

// MARK: - Financial Forecasting Class
class FinancialForecasting {
    var analysis: FinancialAnalysis

    init(analysis: FinancialAnalysis) {
        self.analysis = analysis
    }

    func forecastRevenue(growthRate: Double) -> [Int: Double] {
        var forecastedRevenues = [Int: Double]()
        if let lastStatement = analysis.statements.last {
            var lastRevenue = lastStatement.revenue
            for year in 1...5 { // Forecasting for the next 5 years
                lastRevenue *= (1 + growthRate)
                forecastedRevenues[lastStatement.year + year] = lastRevenue
            }
        }
        return forecastedRevenues
    }

    func forecastCashFlows(growthRate: Double) -> [Int: Double] {
        var forecastedCashFlows = [Int: Double]()
        if let lastStatement = analysis.statements.last {
            var lastCashFlow = lastStatement.operatingCashFlow
            for year in 1...5 {
                lastCashFlow *= (1 + growthRate)
                forecastedCashFlows[lastStatement.year + year] = lastCashFlow
            }
        }
        return forecastedCashFlows
    }

    // Additional forecasting methods
}

// MARK: - Valuation Model Class
class ValuationModel {
    var forecasting: FinancialForecasting
    var discountRate: Double

    init(forecasting: FinancialForecasting, discountRate: Double) {
        self.forecasting = forecasting
        self.discountRate = discountRate
    }

    func calculateDCF() -> Double {
        let cashFlows = forecasting.forecastCashFlows(growthRate: 0.05)
        var dcfValue = 0.0
        for (year, cashFlow) in cashFlows {
            dcfValue += cashFlow / pow(1 + discountRate, Double(year))
        }
        return dcfValue
    }

    // Additional valuation methods
}
