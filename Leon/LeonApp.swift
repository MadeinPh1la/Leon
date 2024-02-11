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
    
    // Create an instance of AuthViewModel
    @StateObject var authViewModel = AuthViewModel()

    // Initialize Firebase
    init() {
        FirebaseApp.configure()
    }
        
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
            
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
            
            // Provide AuthViewModel as an environment object
                .environmentObject(authViewModel)

        }
        .modelContainer(sharedModelContainer)
        
    }
}
