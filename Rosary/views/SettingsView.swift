//
//  SettingsView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settings: GlobalSettings
    
    var body: some View {
        
        NavigationStack {
            List {
                Section  {
                    NavigationLink(
                        destination: ThemeSettingsView()
                    ) {
                        Text("Theme (\(settings.isDarkModeEnabled ? "Dark" : "Light"))")
                    }
                    
                    NavigationLink(
                        destination: HighlightColorSettingsView()
                    ) {
                        Text("Highlight Color")
                            .foregroundStyle(settings.highlightColor)
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

struct HighlightColorSettingsView: View {
    
    @EnvironmentObject var settings: GlobalSettings

    var body: some View {
        VStack {
            ColorPicker("Highlight Color", selection: $settings.highlightColor)
            Spacer()
        }.padding()
    }
}

struct ThemeSettingsView: View {

    @EnvironmentObject var settings: GlobalSettings

    var body: some View {
        
        VStack {
            Toggle("Dark", isOn: $settings.isDarkModeEnabled)
            Divider()
            Toggle("Light", isOn: $settings.isLightModeEnabled)
        }
        .padding()
        Spacer()

    }
}

struct AboutView: View {
    var body: some View {
        
        VStack {
            Text("Chidume Nnamdi")
            Text("kurtwanger40@gmail.com")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(GlobalSettings())
}
