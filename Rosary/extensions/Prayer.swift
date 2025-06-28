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
        self.id = custom.id // UUID().hashValue
    }
    
    init(from dataItem: PrayerSwiftDataItem) {
        self.name = dataItem.name
        self.type = .single
        self.data = dataItem.data
        self.id = dataItem.id // UUID().hashValue
    }
}
