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
    var id: UUID = UUID()
    var name: String
    var data: String
    var orderIndex: Int
    var type: PrayerEnum
    var sectionId: UUID?
    var customPrayer: CustomPrayer?

    init(
        name: String,
        data: String,
        orderIndex: Int,
        type: PrayerEnum = .single,
        customPrayer: CustomPrayer
    ) {
        self.name = name
        self.data = data
        self.orderIndex = orderIndex
        self.customPrayer = customPrayer
        self.type = type
    }
        
    init(
        name: String,
        data: String,
        orderIndex: Int,
        type: PrayerEnum = .single
    ) {
        self.name = name
        self.data = data
        self.orderIndex = orderIndex
        self.type = type
    }
    
    init(
        name: String,
        data: String,
        orderIndex: Int,
        type: PrayerEnum = .single,
        sectionId: UUID = UUID(),
        customPrayer: CustomPrayer
    ) {
        self.name = name
        self.data = data
        self.orderIndex = orderIndex
        self.sectionId = sectionId
        self.customPrayer = customPrayer
        self.type = type
    }


}

@Model
class CustomPrayer {
    var id: UUID = UUID()
    var name: String
    var orderIndex: Int
    var prayerSwiftDataItems: [PrayerSwiftDataItem]
    var isRosary: Bool = false

    init(
        name: String,
        orderIndex: Int,
        prayerSwiftDataItems: [PrayerSwiftDataItem]
    ) {
        self.name = name
        self.orderIndex = orderIndex
        self.prayerSwiftDataItems = prayerSwiftDataItems
    }
}
