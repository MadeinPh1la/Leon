//
//  ContentView.swift
//  Leon
//
//  Created by Kevin Downey on 1/18/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: FinancialView(viewModel: FinancialViewModel())) {
                    Text("Show Financial Data")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Main Menu")
        }
    }
}

struct FinancialView: View {
    @ObservedObject var viewModel: FinancialViewModel

    var body: some View {
        List {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Section(header: Text("Income Statements")) {
                ForEach(viewModel.incomeStatements ?? [], id: \.fiscalDateEnding) { statement in
                    IncomeStatementRow(statement: statement)
                }

            }
        }
        .navigationTitle("Financial Data")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.fetchIncomeStatements(forSymbol: "IBM")
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .onAppear {
            viewModel.fetchIncomeStatements(forSymbol: "IBM")
        }
    }
}

struct IncomeStatementRow: View {
    var statement: IncomeStatement

    var body: some View {
        VStack(alignment: .leading) {
            Text("Date: \(statement.fiscalDateEnding)")
                .font(.headline)
            Text("Net Income: \(statement.netIncome)")
                .font(.subheadline)
            // Add more fields as needed
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
