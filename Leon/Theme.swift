//
//  Theme.swift
//  Leon
//
//  Created by Kevin Downey on 3/23/24.
//

import SwiftUI

let interFont = Font.custom("Inter", size: 17)


extension Font {
    static let titleFont = Font.system(size: 22, weight: .bold)
    static let bodyFont = Font.system(size: 16, weight: .regular)

    static func interRegular(size: CGFloat) -> Font {
        return Font.custom("Inter-Regular", size: size)
    }
    
    static func interLight(size: CGFloat) -> Font {
        return Font.custom("Inter-Light", size: size)
    }
    
    static func interMedium(size: CGFloat) -> Font {
        return Font.custom("Inter-Medium", size: size)
    }
    
    static func interBold(size: CGFloat) -> Font {
        return Font.custom("Inter-Bold", size: size)
    }
}

