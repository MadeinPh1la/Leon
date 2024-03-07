//
//  DCFData.swift
//  Leon
//
//  Created by Kevin Downey on 2/18/24.
//

import Foundation

struct DCFData: Decodable {
    let dcfModel = DCFModel() // Instance of DCFModel
    let financialData = FinancialData(/* initializer parameters */) // Assuming this is your DCFData or similar

    let dcfValue = dcfModel.calculateDCF(data: financialData) // Correct usage

    var dcfValue: Double
    var freeCashFlow: Double
    var growthRate: Double
    var ebit: Double
    var taxRate: Double
    var capEx: Double
    var changeInWorkingCapital: Double
    var discountRate: Double
    var perpetualGrowthRate: Double
}

