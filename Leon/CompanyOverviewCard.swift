//
//  CompanyOverviewCard.swift
//  Leon
//
//  Created by Kevin Downey on 2/18/24.
//

import SwiftUI

struct CompanyOverviewCard: View {
    var overview: CompanyOverview // Assume this is a model containing the overview data
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(overview.companyName)
                .font(.headline)
            Text(overview.description)
                .font(.body)
            // Add more overview details here
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

