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
    var name: String
    var type: PrayerEnum
    var data: String

    init(id: UUID = UUID(), name: String, type: PrayerEnum, data: String) {
        self.id = id
        self.name = name
        self.type = type
        self.data = data
    }
}

enum PrayerEnum: Int, Codable, CaseIterable {
    case single = 0
    case rosary = 1
    case series = 3
    case bead = 4
    
    static var all: [PrayerEnum] {
        return [.bead, .rosary, .series, .single]
    }
    
    var displayName: String {
        switch self {
        case .single: return "Single Prayer"
        case .series: return "Series Prayer"
        case .rosary: return "Rosary"
        case .bead: return "Bead"
        }
    }
}

