//
//  MainAppView.swift
//  Leon
//
//  Created by Kevin Downey on 3/4/24.
//

import SwiftUI

// Main Financial Model View
struct MainAppView: View {
    @State private var symbol: String = ""
    @ObservedObject var financialViewModel: FinancialViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    var body: some View {
        
        NavigationView {
            
            // Display search
            VStack {
                TextField("Enter Stock Symbol", text: $symbol)
                    .padding()
                Button("Get Quote") {
                    financialViewModel.fetchStockQuote(forSymbol: symbol.uppercased())
                    financialViewModel.fetchCompanyOverview(forSymbol: symbol.uppercased())
                    financialViewModel.fetchDCFData(forSymbol: symbol.uppercased())
                }
            }
        }
        
        ScrollView {
            VStack(spacing: 20) {
                // Display quote information or a placeholder if not available
                if let quote = financialViewModel.quote {
                    QuoteCard(quote: quote)
                } else {
                    Text("No quote available")
                }
                
                // Display company overview if available
                if let overview = financialViewModel.companyOverview {
                    CompanyOverviewCard(overview: overview)
                }
                
                // Display DCF data or a placeholder if not available
                if let dcfData = financialViewModel.dcfData {
                    DCFCard(dcfData: dcfData)
                } else {
                    Text("DCF Data not available")
                }
            }
            .padding() // Apply padding to the VStack content
            // Listen for updates to financial data and log changes
            .onReceive(financialViewModel.$quote) { _ in
                print("Quote updated")
            }
            .onReceive(financialViewModel.$companyOverview) { _ in
                print("Company overview updated")
            }
            .onReceive(financialViewModel.$dcfData) { _ in
                print("DCF data updated")
            }
        }
        
    }
}
