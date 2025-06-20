//
//  MysteryUtils.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 12/06/2025.
//

import Foundation

enum RosaryMystery: String {
    case Joyful = "Joyful Mysteries"
    case Sorrowful = "Sorrowful Mysteries"
    case Glorious = "Glorious Mysteries"
    case Luminous = "Luminous Mysteries"

    static func today() -> RosaryMystery {
        let weekday = Calendar.current.component(.weekday, from: Date())
        switch weekday {
        case 1: return .Glorious     // Sunday
        case 2, 7: return .Joyful    // Monday, Saturday
        case 3, 6: return .Sorrowful // Tuesday, Friday
        case 4: return .Glorious     // Wednesday
        case 5: return .Luminous     // Thursday
        default: return .Joyful
        }
    }
    
    static func mystery() -> [String] {
        
        let today = RosaryMystery.today();
        let mystery = Mystery()
        
        switch today {
        case .Joyful: return mystery.Joyful
        case .Sorrowful: return mystery.Sorrowful
        case .Glorious: return mystery.Glorious
        case .Luminous: return mystery.Luminous
        }
    }
    
    static func mysteryTitle(index: Int) -> String {
        
        var title: String = ""
        // The five sorrowful mysteries: First
        
        switch index {
        case 0:
            title = "The First"
            case 1:
            title = "The Second"
        case 2:
            title = "The Third"
        case 3:
            title = "The Fourth"
        case 4:
            title = "The Fifth"
        default:
            title = ""
        }
        
        return "The Five " + RosaryMystery.today().rawValue + ". " + title
        
    }
    
}



struct Mystery {
    
    let Joyful = ["The Annunciation", "The Visitation", "The Birth of Jesus", "The Presentation of Jesus", "The Finding of Jesus in the Temple."]
    
    let Sorrowful = ["The Agony in the Garden", "The Scourging at the Pillar", "The Crowning with Thorns", "The Carrying of the Cross", "The Crucifixion"]
    
    let Glorious = ["The Resurrection", "The Ascension", "The Descent of the Holy Spirit", "The Assumption", "The Coronation of Mary"]
    let Luminous = ["The Baptism of Jesus", "The Miracle at Cana", "The Proclamation of the Kingdom", "The Transfiguration", "The Institution of the Eucharist"]
}
