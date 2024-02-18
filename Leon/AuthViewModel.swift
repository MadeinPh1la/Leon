//
//  AuthViewModel.swift
//  Leon
//
//  Created by Kevin Downey on 2/18/24.
//

import Foundation
import FirebaseAuth
import Combine

// User Authentication
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    
    init() {
        checkAuthState()
    }
    
    func checkAuthState() {
        isAuthenticated = Auth.auth().currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    print("Sign in error: \(error.localizedDescription)")
                    return
                }
                self?.isAuthenticated = true
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    print("Sign up error: \(error.localizedDescription)")
                    completion(false, error)
                    return
                }
                self?.isAuthenticated = true
                completion(true, nil)
            }
        }
    }
}
