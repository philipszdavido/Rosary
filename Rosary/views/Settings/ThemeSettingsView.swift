//
//  ThemeSettingsView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 17/06/2025.
//

import SwiftUI

struct ThemeSettingsView: View {

    @EnvironmentObject var settings: GlobalSettings
    
    var body: some View {
        
        VStack {
            Toggle("Dark", isOn: Binding<Bool>(
                get: { settings.theme == .dark},
                set: {_ in settings.theme = .dark}
            ))
            
            Divider()
            Toggle("Light", isOn: Binding<Bool>(
                get: { settings.theme == .light},
                set: {_ in settings.theme = .light}
            ))
        }
        .padding()
        Spacer()
        
    }
}

#Preview {
    ThemeSettingsView().environmentObject(GlobalSettings())
}
