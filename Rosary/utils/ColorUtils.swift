//
//  ColorUtils.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 12/06/2025.
//

import Foundation
import SwiftUICore

extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

let colors: [Color] = [
    .blue,
    .orange,
    Color(red: 251/255, green: 128/255, blue: 128/255)
]

var randomColor: Color {
    colors.randomElement() ?? Color(red: 251/255, green: 128/255, blue: 128/255)
}
