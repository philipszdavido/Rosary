//
//  Prayer.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 28/06/2025.
//

import Foundation

extension Prayer {
    init(from custom: CustomPrayer) {
        self.name = custom.name
        self.type = custom.isRosary ? .rosary : .series
        self.data = ""
        self.id = custom.id
    }
    
    init(from dataItem: PrayerSwiftDataItem) {
        self.name = dataItem.name
        self.type = dataItem.type
        self.data = dataItem.data
        self.sectionId = dataItem.sectionId
        self.id = dataItem.id
    }
}
