//
//  NewsFeedView.swift
//  Leon
//
//  Created by Kevin Downey on 3/20/24.
//

import SwiftUI

struct NewsFeedView: View {
    @EnvironmentObject var viewModel: FinancialViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    let symbol: String

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.newsFeed, id: \.self) { article in
                        NewsArticleCard(article: article)
                    }
                }
            }
            .navigationTitle("News")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out") {
                        authViewModel.signOut()
                    }
                }
            }
        }
        .onAppear {
            print("Loading news feed for symbol: \(symbol)")
            viewModel.loadNewsFeed(forSymbol: "AAPL")
        }
    }
}

