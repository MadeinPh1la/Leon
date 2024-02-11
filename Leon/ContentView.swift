//
//  ContentView.swift
//  Leon
//
//  Created by Kevin Downey on 1/18/24.
//

import SwiftUI
import SwiftData
import FirebaseAuth

// If user is authenticated, display main financial view. If user is not authenticated, display sign in view.
struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
           Group {
               if authViewModel.isAuthenticated {
                   // User is authenticated, show the main app content
                   MainAppView()
               } else {
                   // User is not authenticated, show sign-in or sign-up options
                   SignInView()
               }
           }
       }
   }

// Sign In View
struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(authViewModel.isLoading)  // Disable input while loading
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(authViewModel.isLoading)  // Disable input while loading
            
            if authViewModel.isLoading {
                ProgressView()  // Show loading indicator
            } else {
                Button("Sign In") {
                    authViewModel.signIn(email: email, password: password)
                }
            }
        }
        .padding()
    }
}

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button("Sign Up") {
                signUpUser()
            }
            .padding()
        }
        .padding()
    }
    
    // Sign Up
    
    func signUpUser() {
        // Assuming you have a viewModel or similar object handling authentication
        AuthViewModel().signUp(email: email, password: password) { success, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else if success {
                // Handle successful sign-up, e.g., navigate to the main content of your app
            }
        }
    }
}

// Main Financial Model View
struct MainAppView: View {
    @StateObject private var viewModel = FinancialViewModel()
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
