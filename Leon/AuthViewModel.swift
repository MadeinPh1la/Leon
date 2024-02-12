//
//  AuthViewModel.swift
//  Leon
//
//  Created by Kevin Downey on 2/12/24.
//

import Foundation
import FirebaseAuth
import Combine

//User Authentication
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        // Check the authentication state at initialization
        checkAuthState()
    }
    
    func checkAuthState() {
        // Update isAuthenticated based on Firebase Auth state
        isAuthenticated = Auth.auth().currentUser != nil
    }
    
    //Sign In
    func signIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        isLoading = true  // Start loading
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false  // Stop loading
                if let error = error {
                    // If there's an error, call the completion handler with false and the error
                    completion(false, error)
                    return
                }
                // On success, update isAuthenticated and call the completion handler with true and nil for the error
                self?.isAuthenticated = true
                completion(true, nil)
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
    func signUp(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
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
