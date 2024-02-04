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
    @State private var symbol: String = ""

    var body: some View {
        NavigationView {
            
            // Display search
            
            VStack {
                TextField("Enter Stock Symbol", text: $symbol)
                    .padding()
                Button("Get Quote") {
                    viewModel.fetchStockQuote(forSymbol: symbol.uppercased())
                }
                .padding()
                
                // Display stock quote information

                if let stockQuote = viewModel.stockQuote {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Symbol: \(stockQuote.symbol)")
                        Text("Latest Price: \(stockQuote.price ?? "Data not available")")
                        Text("Latest Trading Day: \(stockQuote.latestTradingDay ?? "Data not available")")
                        Text("Open: \(stockQuote.open ?? "Data not available")")
                        Text("High: \(stockQuote.high ?? "Data not available")")
                        Text("Low: \(stockQuote.low ?? "Data not available")")
                        Text("Volume: \(stockQuote.volume ?? "Data not available")")
                        Text("Previous Close: \(stockQuote.previousClose ?? "Data not available")")
                        Text("Today's Change: \(stockQuote.change ?? "Data not available")")
                        Text("Today's Change %: \(stockQuote.changePercent ?? "Data not available")")
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Stock Quote")
            .padding()
        }
    }
}
