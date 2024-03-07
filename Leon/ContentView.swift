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
    @State private var symbol: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
  //  @StateObject var financialViewModel = FinancialViewModel()
    @ObservedObject var financialViewModel = FinancialViewModel()


    var body: some View {
           Group {
               if authViewModel.isAuthenticated {
                   // User is authenticated, show the main app content
                   MainAppView(financialViewModel: financialViewModel)
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

