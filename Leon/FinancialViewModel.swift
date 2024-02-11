//
//  FinancialViewModel.swift
//  Leon
//
//  Created by Kevin Downey on 1/19/24.
//

import FirebaseAuth
import Foundation
import Combine

//User Authentication
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false  // Add this line to track loading state
    
    init() {
        // Check the authentication state at initialization
        checkAuthState()
    }
    
    func checkAuthState() {
        // Update isAuthenticated based on Firebase Auth state
        isAuthenticated = Auth.auth().currentUser != nil
    }
    
    //Sign In
    func signIn(email: String, password: String) {
        isLoading = true  // Start loading
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false  // Stop loading
                if let error = error {
                    // Handle error
                    return
                }
                self?.isAuthenticated = true
            }
        }
    }
    // Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    // Sign Up
    func signUp(email: String, password: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        // Implementation
        isLoading = true  // Start loading
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false  // Stop loading
                if let error = error {
                    // Handle error
                    return
                }
                self?.isAuthenticated = true
            }
        }
    }
}
    class FinancialViewModel: ObservableObject {
        @Published var stockQuote: StockQuote?
        @Published var errorMessage: String?
        
        //Fetch stock quotes
        func fetchStockQuote(forSymbol symbol: String) {
            
            API.shared.fetchStockQuote(forSymbol: symbol) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let quote):
                        print("Fetched quote: \(quote)")
                        self?.stockQuote = quote
                    case .failure(let error):
                        print("Error fetching stock quote: \(error.localizedDescription)")
                        self?.errorMessage = "Error fetching data"
                    }
                }
            }
        }
    }

