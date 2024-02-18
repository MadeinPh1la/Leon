//
//  SwiftUIView.swift
//  Leon
//
//  Created by Kevin Downey on 2/18/24.
//

import SwiftUI

struct DCFCard: View {
    var dcfData: DCFData

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DCF Value: \(dcfData.dcfValue, specifier: "%.2f")")
                .font(.title)
                .fontWeight(.bold)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.1)))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.green, lineWidth: 2)
        )
        .padding()
    }
}

