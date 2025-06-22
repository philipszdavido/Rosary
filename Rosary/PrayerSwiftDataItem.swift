//
//  Item.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import Foundation
import SwiftData

@Model
final class PrayerSwiftDataItem {
    var data: String
    var name: String
    
    init(data: String, name: String) {
        self.data = data
        self.name = name
    }
}
