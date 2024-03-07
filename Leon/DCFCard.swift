//
//  DCFCard.swift
//  Leon
//
//  Created by Kevin Downey on 3/4/24.
//

import SwiftUI

struct DCFCard: View {
   // @ObservedObject var viewModel: FinancialViewModel
    var dcfData: DCFData

    var body: some View {
            VStack {
                Text("DCF Value: \(dcfData.dcfValue, specifier: "%.2f")")
                Text("Free Cash Flow: \(dcfData.freeCashFlow, specifier: "%.2f")")
            }
        }
    }
