//
//  Item.swift
//  Leon
//
//  Created by Kevin Downey on 1/18/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
