//
//  MainAppView.swift
//  Leon
//
//  Created by Kevin Downey on 3/4/24.
//

import SwiftUI

struct MainAppView: View {
    @State private var symbol: String = ""
    @StateObject var financialViewModel = FinancialViewModel(api: API.shared)
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                symbolEntryField // Extracted symbol entry TextField
                
                fetchButton // Extracted button for fetching data
                
                dataDisplayScrollView // Extracted ScrollView for displaying data
            }
            .navigationTitle("Stock Data")
            .toolbar {
                signOutToolbarItem // Extracted ToolbarItem for signing out
            }
        }
    }
}

// Subviews
private extension MainAppView {
    var symbolEntryField: some View {
        TextField("Enter Stock Symbol", text: $symbol)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }

    var fetchButton: some View {
        Button("Get Quote", action: fetchFinancialData)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
    
    var dataDisplayScrollView: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let quote = financialViewModel.quote {
                    QuoteCard(quote: quote)
                } else {
                    Text("No quote available").padding()
                }
                
                if let overview = financialViewModel.companyOverview {
                    CompanyOverviewCard(overview: overview)
                }
                
                // Display DCF Value
                if let dcfValue = financialViewModel.dcfValue {
                    Text("DCF Value: \(dcfValue, specifier: "%.2f")")
                        }
                    else {
                        Text("DCF Data not available")
                        
                            .padding()
                    }
                }
            }
        }
    
    var signOutToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Sign Out", action: authViewModel.signOut)
        }
    }
}

//Actions
private extension MainAppView {
    func fetchFinancialData() {
        financialViewModel.fetchStockQuote(forSymbol: symbol.uppercased())
        financialViewModel.fetchCompanyOverview(forSymbol: symbol.uppercased())
        financialViewModel.loadDCFValue(forSymbol: symbol.uppercased())
    }
}
