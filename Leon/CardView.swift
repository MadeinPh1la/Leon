//
//  CardView.swift
//  Leon
//
//  Created by Kevin Downey on 3/23/24.
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    var backgroundColor: Color = .background // Default background color

    init(backgroundColor: Color = .background, @ViewBuilder content: () -> Content) {
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading) {
            content
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
