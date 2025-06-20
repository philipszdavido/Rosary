//
//  SettingsView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settings: GlobalSettings
    @State private var showBeadCounting = true
        
    var body: some View {
        
        let showBeadCountingBinding = Binding<Bool>(
            get: { settings.showBeadCounting },
            set: {
                if $0 {
                    settings.showBeadCounting = true
                } else {
                    settings.showBeadCounting = false
                }
            })

        NavigationView {
            List {
                Section("Colors")  {
                    NavigationLink(
                        destination: ThemeSettingsView()
                    ) {
                        Text("Theme (\(settings.theme == .dark ? "Dark" : "Light"))")
                        settings.theme == .dark ? Image(systemName: "moon.fill") : Image(systemName: "sun.horizon")
                    }
                    
                    NavigationLink(
                        destination: HighlightColorSettingsView()
                    ) {
                        HStack {
                            Text("Highlight Color")
                            Circle().fill(settings.highlightColor)
                                .frame(width: 20, height: .infinity)
                        }
                    }
                    
                }
                
                Section("Rosary") {
                    
                    // show bead counting
                    Toggle(
                        "Show Bead Counting",
                        isOn: showBeadCountingBinding
                    )
                    
                    // speak prayer aloud
                    NavigationLink("Speech") {
                        SpeechSettingsView()
                    }
                    
                    // bead not-prayed color
                    // bead prayed color
                    // bead currently praying color
                    NavigationLink("Bead Color") {
                        BeadColorSettingsView()
                    }
                    
                }
                
                Section {
                    NavigationLink(
                        destination: AboutView()
                    ) {
                        Text("About")
                    }

                }
            }.navigationTitle(Text("Settings"))
        }
    }
}

struct SettingsView_Preview: View {    
    var body: some View {
        var globalSettings = GlobalSettings()
        SettingsView()
            .environmentObject(globalSettings)
            .preferredColorScheme(globalSettings.theme == .dark ? .dark : .light)
    }
}

#Preview {
    SettingsView_Preview()
}
