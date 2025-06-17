//
//  GlobalSettings.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 14/06/2025.
//

import Foundation
import SwiftUICore
import UIKit

enum Theme: Int {
    //    case dark = 0
    //    case light = 1
    case light = 0
        case dark = 1
        case system = 2
}

extension UserDefaults {
    
    func setColor(color: Color) {
        let uiColor = UIColor(color)
        let data = NSKeyedArchiver.archivedData(withRootObject: uiColor)
        set(data, forKey: "highlightColor")
    }
    
    func getColor() -> Color? {
        guard let data = data(forKey: "highlightColor") else { return nil }
        let uiColor =  NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor
        
        guard let uiColor = uiColor else {
            return nil
        }
        
        return Color(uiColor)
    }
    
    func setTheme(theme: Theme) {
        set(theme.rawValue, forKey: "theme")
    }
    
    func getTheme() -> Theme {
        guard let rawValue = integer(forKey: "theme") as? Int else {
            return .dark
        }
        return Theme(rawValue: rawValue)!
    }
    
}


class GlobalSettings: ObservableObject {
    
    let userDefaults = UserDefaults()
    
    @Published var theme: Theme
    {
        didSet {
            // update localstorage
            userDefaults.setTheme(theme: theme)

        }
    }

    @Published var highlightColor: Color
    {
        didSet {
            
            userDefaults.setColor(color: highlightColor)
            
        }
    }
    
    init(
        theme: Theme,
        highlightColor: Color
    ) {
        self.theme = theme
        self.highlightColor = highlightColor
    }
    
    init () {
        self.theme = userDefaults.getTheme()
        self.highlightColor = userDefaults.getColor() ?? .orange
    }
    
}
