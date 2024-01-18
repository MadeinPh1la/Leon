//
//  ContentView.swift
//  Leon
//
//  Created by Kevin Downey on 1/18/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var revenue: String = ""
    @State private var expenses: String = ""
    @State private var netIncome: String = ""
    @State private var result: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Input Financial Data")) {
                    TextField("Revenue", text: $revenue)
                    TextField("Expenses", text: $expenses)
                    TextField("Net Income", text: $netIncome)
                }

                Section {
                    Button("Calculate Profit Margin") {
                        calculateProfitMargin()
                    }
                }

                Section(header: Text("Results")) {
                    Text(result)
                }
            }
            .navigationBarTitle("Financial Analysis")
        }
    }

    func calculateProfitMargin() {
        // ... Calculation Logic ...
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
