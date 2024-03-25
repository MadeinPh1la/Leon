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
    @State private var isShowingFinancialDetails = false

    
    init(financialViewModel: FinancialViewModel) {
        self.financialViewModel = financialViewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                symbolEntryField
                
                fetchButton
                
                // Programmatically trigger navigation to FinancialDetailView
                NavigationLink(destination: FinancialDetailView(financialViewModel: financialViewModel), isActive: $isShowingFinancialDetails) {
                        EmptyView() // This view is invisible and serves only as a navigation trigger
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
            .background()

            
        }
        
    }
    
    // Subviews
    private var symbolEntryField: some View {
        TextField("Enter Stock Symbol", text: $symbol)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    private var fetchButton: some View {
        Button("Get Quote") {
            financialViewModel.symbol = self.symbol // Update the ViewModel's symbol
            financialViewModel.fetchFinancialData(forSymbol: financialViewModel.symbol)
            isShowingFinancialDetails = true
        }
        .foregroundColor(.white) // Set text color to white
        .padding() // Add padding around the text
        .background(.mint) // Set background color to blue
        .cornerRadius(10) // Apply corner radius
        .shadow(radius: 5) // Add shadow
    }
    
    private var dataDisplayScrollView: some View {
        ScrollView {
            VStack(spacing: 10) {
                
                
                // Trending section
                TrendingStocksView(title: "Top Gainers", stocks: Array(financialViewModel.topGainers.prefix(2)))
                
                
                NavigationLink(destination: StocksListView(title: "Top Gainers", stocks: financialViewModel.topGainers)) {
                    Text("View All Top Gainers")
                        .foregroundColor(.blue)
                }
                TrendingStocksView(title: "Top Losers", stocks: Array(financialViewModel.topLosers.prefix(2)))
                
                NavigationLink(destination: StocksListView(title: "Top Losers", stocks: financialViewModel.topLosers)) {
                    Text("View All Top Losers")
                        .foregroundColor(.blue)
                }
                
            }
        }
    }
    
    private var signOutToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Sign Out", action: authViewModel.signOut)
        }
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
//Actions
//private extension MainAppView {
//    func fetchFinancialData() {
//        financialViewModel.fetchStockQuote(forSymbol: symbol.uppercased())
//        financialViewModel.fetchCompanyOverview(forSymbol: symbol.uppercased())
//        financialViewModel.loadDCFValue(forSymbol: symbol.uppercased())
//    }
//}
