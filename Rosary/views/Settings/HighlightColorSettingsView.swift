//
//  HighlightColorSettingsView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 17/06/2025.
//

import SwiftUI

struct HighlightColorSettingsView: View {
    
    @EnvironmentObject var settings: GlobalSettings

    var body: some View {
        VStack {
            ColorPicker("Highlight Color", selection: $settings.highlightColor)
            Spacer()
        }.padding()
    }
}

#Preview {
    HighlightColorSettingsView()
        .environmentObject(GlobalSettings())
}
