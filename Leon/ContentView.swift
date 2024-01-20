//
//  ContentView.swift
//  Leon
//
//  Created by Kevin Downey on 1/18/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var viewModel = FinancialViewModel()

    var body: some View {
        VStack {
            
            
            if let incomeStatements = viewModel.incomeStatements {
                           List(incomeStatements, id: \.fiscalDateEnding) { statement in
                               VStack(alignment: .leading) {
                                   Text("Date: \(statement.fiscalDateEnding)")
                                   Text("Net Income: \(statement.netIncome)")
                                   // Display other details...
                               }
                           }
                       } else {
                           Text("No data to display")
                       }

                       Button("Fetch IBM Income Statements") {
                           viewModel.fetchIncomeStatements(forSymbol: "IBM") // Example symbol
                       }
            
            
            // Example usage: Displaying income statements
//            if let incomeStatements = viewModel.financialModel?.incomeStatements {
//                List(incomeStatements, id: \.fiscalDateEnding) { incomeStatement in
//                                    VStack(alignment: .leading) {
//                                        Text("Date: \(incomeStatement.fiscalDateEnding)")
//                                        Text("Net Income: \(incomeStatement.netIncome)")
//                                        Text("Total Revenue: \(incomeStatement.totalRevenue)")
//                                        // Display other fields as required
//                                    }
//                                }
//            } else {
//                Text("No data to display")
//            }
// 
            
            // Fetch data button
//            Button("Fetch Financial Data") {
//                viewModel.fetchIncomeStatements { result in
//                    switch result {
//                    case .success(let data):
//                        print("Income Statements fetched successfully: \(data)")
//                    case .failure(let error):
//                        print("Error fetching Income Statements: \(error.localizedDescription)")
//                    }
//                }
//                viewModel.fetchBalanceSheets { result in
//                    // Similar handling for balance sheets
//                }
                // Repeat for other data types like Cash Flow Statements and Economic Indicators
            }
            
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
