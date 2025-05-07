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
}

enum RosaryMystery: String {
    case Joyful = "Joyful Mysteries"
    case Sorrowful = "Sorrowful Mysteries"
    case Glorious = "Glorious Mysteries"
    case Luminous = "Luminous Mysteries"

    static func today() -> RosaryMystery {
        let weekday = Calendar.current.component(.weekday, from: Date())
        switch weekday {
        case 1: return .Glorious     // Sunday
        case 2, 6: return .Joyful    // Monday, Saturday
        case 3, 5: return .Sorrowful // Tuesday, Friday
        case 4: return .Glorious     // Wednesday
        case 5: return .Luminous     // Thursday
        default: return .Joyful
        }
    }
}

struct Mystery {
    let type: RosaryMystery;
    let first: String;
    let second: String;
    let third: String;
    let fourth: String;
    let fifth: String;
}
