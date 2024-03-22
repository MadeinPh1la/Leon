//
//  MainAppView.swift
//  Leon
//
//  Created by Kevin Downey on 3/4/24.
//

import SwiftUI

struct MainAppView: View {
    @State private var symbol: String = ""
    @ObservedObject var financialViewModel: FinancialViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init(financialViewModel: FinancialViewModel) {
        self.financialViewModel = financialViewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                symbolEntryField
                
                fetchButton
                
                // Trending section
                if !financialViewModel.topGainers.isEmpty {
                                Text("Top Gainers").font(.headline).padding(.top)
                                ForEach(financialViewModel.topGainers) { stock in
                                    VStack(alignment: .leading) {
                                        Text(stock.ticker).fontWeight(.bold)
                                        Text("Price: \(stock.price)")
                                        Text("Change: \(stock.changeAmount) (\(stock.changePercentage)%)")
                                    }
                                    .padding(.vertical, 2)
                                }
                            }
                            
                            if !financialViewModel.topLosers.isEmpty {
                                Text("Top Losers").font(.headline).padding(.top)
                                ForEach(financialViewModel.topLosers) { stock in
                                    VStack(alignment: .leading) {
                                        Text(stock.ticker).fontWeight(.bold)
                                        Text("Price: \(stock.price)")
                                        Text("Change: \(stock.changeAmount) (\(stock.changePercentage)%)")
                                    }
                                    .padding(.vertical, 2)
                                }
                            }
                
                dataDisplayScrollView
            }
            
            .navigationTitle("Stock Data")
            .toolbar {
                signOutToolbarItem
            }
            
            .onAppear {
                 financialViewModel.loadTrendingStocks()
             }
        }
            
        }
    
    // Subviews
    private var symbolEntryField: some View {
        TextField("Enter Stock Symbol", text: $symbol)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    private var fetchButton: some View {
        Button("Get Quote", action: fetchFinancialData)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
    
    private var dataDisplayScrollView: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                if let quote = financialViewModel.quote {
                    QuoteCard(quote: quote)
                }
                
                if let overview = financialViewModel.companyOverview {
                    CompanyOverviewCard(overview: overview)
                }
                
                // Displaying the DCF Share Price
                if let sharePrice = financialViewModel.sharePrice {
                    Text("DCF Share Price: \(sharePrice, specifier: "%.2f")")
                }
                
            }
        }
    }

    
    private var signOutToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Sign Out", action: authViewModel.signOut)
        }
    }

    // Actions
    func fetchFinancialData() {
        financialViewModel.fetchStockQuote(forSymbol: symbol.uppercased())
        financialViewModel.fetchCompanyOverview(forSymbol: symbol.uppercased())
        financialViewModel.loadDCFValue(forSymbol: symbol.uppercased())
        financialViewModel.loadNewsFeed(forSymbol: symbol.uppercased())
    }
}

//struct MainAppView: View {
//    @State private var symbol: String = ""
//    @ObservedObject var financialViewModel: FinancialViewModel
//    @EnvironmentObject var authViewModel: AuthViewModel
//    
//    init(financialViewModel: FinancialViewModel) {
//        self.financialViewModel = financialViewModel
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                symbolEntryField // Extracted symbol entry TextField
//                
//                fetchButton // Extracted button for fetching data
//                
//                dataDisplayScrollView // Extracted ScrollView for displaying data
//            }
//            .navigationTitle("Stock Data")
//            .toolbar {
//                signOutToolbarItem // Extracted ToolbarItem for signing out
//            }
//        }
//    }
//}
//
//// Subviews
//private extension MainAppView {
//    var symbolEntryField: some View {
//           HStack {
//               Image(systemName: "magnifyingglass")
//                   .foregroundColor(.gray)
//               TextField("Enter Stock Symbol", text: $symbol)
//                   .padding()
//                   .background(Color(.systemBackground))
//                   .cornerRadius(10)
//                   .shadow(radius: 1)
//                   .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//           }
//           .padding()
//       }
//
//       var fetchButton: some View {
//           Button("Get Quote", action: fetchFinancialData)
//               .padding()
//               .foregroundColor(.white)
//               .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
//               .cornerRadius(10)
//               .shadow(radius: 2)
//       }
//    
//    var dataDisplayScrollView: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                if let quote = financialViewModel.quote {
//                    QuoteCard(quote: quote)
//                } else {
//                    Text("").padding()
//                }
//                
//                if let overview = financialViewModel.companyOverview {
//                    CompanyOverviewCard(overview: overview)
//                }
//                
//                // Displaying the DCF Share Price
//                if let sharePrice = financialViewModel.sharePrice {
//                    Text("DCF Share Price: \(sharePrice, specifier: "%.2f")")
//                } else {
//                    Text("")
//                }
//            
//                }
//            }
//        }
//    
//    var signOutToolbarItem: some ToolbarContent {
//        ToolbarItem(placement: .navigationBarTrailing) {
//            Button("Sign Out", action: authViewModel.signOut)
//        }
//    }
//}
//
////Actions
//private extension MainAppView {
//    func fetchFinancialData() {
//        financialViewModel.fetchStockQuote(forSymbol: symbol.uppercased())
//        financialViewModel.fetchCompanyOverview(forSymbol: symbol.uppercased())
//        financialViewModel.loadDCFValue(forSymbol: symbol.uppercased())
//    }
//}
