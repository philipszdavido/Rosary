//
//  Item.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import Foundation
import SwiftData

@Model
class PrayerSwiftDataItem {
    var id: UUID
    var name: String
    var data: String
    var orderIndex: Int

    init(name: String, data: String, orderIndex: Int) {
        self.id = UUID()
        self.name = name
        self.data = data
        self.orderIndex = orderIndex
    }
}

