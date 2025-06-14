//
//  GlobalSettings.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 14/06/2025.
//

import Foundation
import SwiftUICore
import UIKit


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
    
}


class GlobalSettings: ObservableObject {
    
    @Published var isDarkModeEnabled: Bool = UserDefaults().bool(forKey: "isDarkModeEnabled")
    {
        didSet {
            // update localstorage
            UserDefaults.standard
                .set(isDarkModeEnabled, forKey: "isDarkModeEnabled")
        }
    }

    @Published var isLightModeEnabled: Bool = UserDefaults().bool(forKey: "isLightModeEnabled")
    {
        didSet {
            // update localstorage
            UserDefaults.standard
                .set(isLightModeEnabled, forKey: "isLightModeEnabled")
        }
    }

    @Published var highlightColor: Color = UserDefaults().getColor() ?? .orange
    {
        didSet {
            
            UserDefaults().setColor(color: highlightColor)
            
        }
    }
    
}
