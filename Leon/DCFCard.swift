//
//  DCFCard.swift
//  Leon
//
//  Created by Kevin Downey on 3/4/24.
//

import SwiftUI

struct DCFCard: View {
    @ObservedObject var viewModel: FinancialViewModel  // Ensure this is passed to the view

    var dcfData: DCFData

    var body: some View {
        VStack {
            Text("DCF Value: \(viewModel.dcfValue ?? 0.0, specifier: "%.2f")")
            // Debug DCF value display
//             Text("Debug DCF Value: \(dcfData.dcfValue ?? 0.0, specifier: "%.2f")")
        }
    }
}
