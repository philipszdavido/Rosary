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

struct Prayer : Identifiable, Hashable {
    let id: Int = UUID().hashValue;
    let name: String;
    let type: PrayerEnum;
    let data: String;
}

enum PrayerEnum: Int {
    case single = 0
    case rosary = 1
    case bead = 3
}
