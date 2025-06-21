//
//  SeriesPrayerView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 21/06/2025.
//

import SwiftUI

struct SeriesPrayerView: View {
    
    @Binding var prayer: Prayer
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SeriesPrayerView(prayer: Binding<Prayer>(
        get: {Prayer(name: "", type: .single, data: "")},
        set: { _ in}
    ))
}
