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
        .preferredColorScheme(GlobalSettings().theme == .dark ? .dark : .light)
}
