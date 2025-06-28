//
//  Types.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import Foundation

enum RosaryType: Int {
    case auto = 0
    case manual = 1
    case none = 3
}

struct Prayer: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let type: PrayerEnum
    let data: String

    init(id: UUID = UUID(), name: String, type: PrayerEnum, data: String) {
        self.id = id
        self.name = name
        self.type = type
        self.data = data
    }
}

enum PrayerEnum: Int, Codable {
    case single = 0
    case rosary = 1
    case series = 3
    case bead = 4
}

