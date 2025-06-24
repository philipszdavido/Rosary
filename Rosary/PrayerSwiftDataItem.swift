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
    var customPrayer: CustomPrayer?

    init(
        name: String,
        data: String,
        orderIndex: Int,
        customPrayer: CustomPrayer
    ) {
        self.id = UUID()
        self.name = name
        self.data = data
        self.orderIndex = orderIndex
        self.customPrayer = customPrayer
    }
    
    init(
        name: String,
        data: String,
        orderIndex: Int
    ) {
        self.id = UUID()
        self.name = name
        self.data = data
        self.orderIndex = orderIndex
    }
}

@Model
class CustomPrayer {
    var id: UUID
    var name: String
    var orderIndex: Int
    var prayerSwiftDataItems: [PrayerSwiftDataItem]

    init(
        name: String,
        orderIndex: Int,
        prayerSwiftDataItems: [PrayerSwiftDataItem]
    ) {
        self.id = UUID()
        self.name = name
        self.orderIndex = orderIndex
        self.prayerSwiftDataItems = prayerSwiftDataItems
    }
}
