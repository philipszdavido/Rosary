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
    case light = 0
    case dark = 1
    case system = 2
}

enum BeadColorType: String, CaseIterable, Identifiable {
    case notPrayed
    case prayed
    case currentlyPraying
    case hailMary
    case ourFather

    var id: String { rawValue }

    var defaultColor: Color {
        switch self {
        case .notPrayed: return .gray
        case .prayed: return .green
        case .currentlyPraying: return .blue
        case .hailMary: return .purple
        case .ourFather: return .orange
        }
    }

    var title: String {
        switch self {
        case .notPrayed: return "Not Prayed"
        case .prayed: return "Prayed"
        case .currentlyPraying: return "Currently Praying"
        case .hailMary: return "Hail Mary"
        case .ourFather: return "Our Father"
        }
    }
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
    
    func setBeadColorType(_ color: Color, for key: String) {
        let uiColor = UIColor(color)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false) {
            set(data, forKey: key)
        }
    }
    
    func getBeadColorType(for key: String, default defaultColor: Color) -> Color {
        if let data = data(forKey: key),
           let uiColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor {
            return Color(uiColor)
        }
        return defaultColor
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
    
    @Published var showBeadCounting: Bool = false
    {
        didSet {
            userDefaults.set(showBeadCounting, forKey: "showBeadCounting")
        }
    }
    
    @Published var beadColors: [BeadColorType: Color] = [:] {
        didSet {
            for (type, color) in beadColors {
                userDefaults.setBeadColorType(color, for: type.rawValue)
            }
        }
    }
    @Published var voice: String {
        didSet {
            userDefaults.set(voice, forKey: "voice")
        }
    }
    
    @Published var speakAloud: Bool {
        didSet {
            userDefaults.set(speakAloud, forKey: "speakAloud")
        }
    }
    
    func color(for type: BeadColorType) -> Color {
        beadColors[type] ?? type.defaultColor
    }
    
    func setColor(_ color: Color, for type: BeadColorType) {
        beadColors[type] = color
    }
    
    init () {
        
        self.theme = userDefaults.getTheme()
        self.highlightColor = userDefaults.getColor() ?? .orange
        
        var loaded: [BeadColorType: Color] = [:]
        for type in BeadColorType.allCases {
            loaded[type] = userDefaults.getBeadColorType(for: type.rawValue, default: type.defaultColor)
        }
        beadColors = loaded
        
        self.voice = userDefaults.string(forKey: "voice") ?? "com.apple.ttsbundle.Samantha-compact"
        self.speakAloud = userDefaults.bool(forKey: "speakAloud") ?? true
    }
    
}
