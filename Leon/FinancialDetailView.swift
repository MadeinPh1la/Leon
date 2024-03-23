//
//  FinancialDetailView.swift
//  Leon
//
//  Created by Kevin Downey on 3/22/24.
//

import SwiftUI

struct FinancialDetailView: View {
    @ObservedObject var financialViewModel: FinancialViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Displaying Stock Quote
                if let quote = financialViewModel.quote {
                    QuoteCard(quote: quote)
                }
                
                // Displaying Company Overview
                if let overview = financialViewModel.companyOverview {
                    CompanyOverviewCard(overview: overview)
                }
                
                // Displaying DCF Share Price as a Card
                VStack {
                    if let dcfSharePrice = financialViewModel.dcfSharePrice {
                        Text("DCF Share Price: \(dcfSharePrice, specifier: "%.2f")")
                            .font(.bodyFont) // Using the custom font from your theme
                            .foregroundColor(.textPrimary) // Custom text color from your theme
                    } else {
                        Text("DCF Share Price not available")
                            .foregroundColor(.textSecondary) // Custom text color for unavailable content
                    }
                }
                .padding() // Add padding inside the card
                .background(Color.background) // Use your theme's background color
                .cornerRadius(10) // Rounded corners for the card-like appearance
                .shadow(radius: 5) // Optional: add a shadow to elevate the card visually
                .padding([.horizontal, .bottom]) // Add some space around the card
            }
            .navigationTitle("Financial Details")
            .onAppear {
                financialViewModel.loadDCFValue()
            }
        }
    }
}
