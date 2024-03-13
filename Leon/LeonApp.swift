//
//  LeonApp.swift
//  Leon
//
//  Created by Kevin Downey on 1/18/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main

struct LeonApp: App {
    
    init() {
            FirebaseApp.configure()
        }

    // Create an instance of AuthViewModel
    @StateObject var authViewModel = AuthViewModel()


    var body: some Scene {
        WindowGroup {
            ContentView()
          
            // Provide AuthViewModel as an environment object
                .environmentObject(authViewModel)


        }
    }
}
