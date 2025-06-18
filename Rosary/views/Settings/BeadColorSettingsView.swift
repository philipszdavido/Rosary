//
//  BeadColorSettingsView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 18/06/2025.
//

import SwiftUI

// bead not-prayed color
// bead prayed color
// bead currently praying color

// hail mary bead color
// our father bead color

struct BeadColorSettingsView: View {
    
    @EnvironmentObject var settings: GlobalSettings
    
    var body: some View {
        List {
            ForEach(BeadColorType.allCases) { type in
                ColorPicker(type.title, selection: Binding(
                    get: { settings.color(for: type) },
                    set: { settings.setColor($0, for: type) }
                ))
            }
        }
    }
}

#Preview {
    BeadColorSettingsView().environmentObject(GlobalSettings())
}
