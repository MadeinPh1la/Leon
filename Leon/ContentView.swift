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
    @StateObject var financialViewModel = FinancialViewModel()

    var body: some View {
           Group {
               if authViewModel.isAuthenticated {
                   // User is authenticated, show the main app content
                   MainAppView(viewModel: financialViewModel)
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
                    authViewModel.signIn(email: email, password: password) { success, error in
                        DispatchQueue.main.async {
                            if success {
                                // Handle successful sign-in, e.g., updating UI or transitioning to another view
                                print("Sign-in successful")
                            } else {
                                // Optionally handle the error, e.g., showing an error message
                                // Make sure to declare a state variable in ContentView to hold the error message
                                print("Sign-in failed: \(error?.localizedDescription ?? "Unknown error")")
                            }
                        }
                    }
                }

            }
        }
        .padding()
    }
}

// Main Financial Model View
struct MainAppView: View {
    @ObservedObject var viewModel: FinancialViewModel
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
                
                
                ScrollView {
                    VStack(spacing: 20) {
                                        
                        if let overview = viewModel.companyOverview {
                            CompanyOverviewCard(overview: overview)
                        }
                        
                        if let quote = viewModel.quote {
                            QuoteCard(quote: quote) // Correctly passing unwrapped `quote`
                        } else {
                            // Handle the case where `quote` is nil
                            Text("No quote available")
                        }
                        
                        if let dcfValue = viewModel.dcfResult {
                            let dcfData = DCFData(dcfValue: dcfValue) // Create an instance of DCFData
                            DCFCard(dcfData: dcfData) // Pass the instance to DCFCard
                        }
                        
                    }
                    .padding()
                }
            }
        }
    

            
        }
    
    }
struct SafeAreaModifier: ViewModifier {
    var topInset: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(.top, topInset.isNaN ? 0 : topInset) // Check for NaN
    }
}

extension View {
    func safeAreaPadding(topInset: CGFloat) -> some View {
        self.modifier(SafeAreaModifier(topInset: topInset))
    }
}

