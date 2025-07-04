//
//  ContentView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @State private var selectedTab: Int = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            
            PrayersViewV2()
            .tabItem {
                Image(systemName: "book.pages")
                Text("Prayers")
            }
            .tag(1)
            
            AddCustomPrayerView()
                .tabItem {
                    Image(systemName: "plus.app")
                    Text("Add Prayer")
                }.tag(2)
            
            ManageCustomPrayersView()
                .tabItem {
                    Image(systemName: "wrench.and.screwdriver.fill")
                    Text("Manage Prayers")
                }.tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
            
        }
    }
}

struct ContentView_Preview: View {
    
    @StateObject var settings = GlobalSettings()
    
    var body: some View {
        ContentView()
            .modelContainer(for: PrayerSwiftDataItem.self, inMemory: true)
            .environmentObject(settings)
            .preferredColorScheme(settings.theme == .dark ? .dark : .light)
    }
}
#Preview {
    ContentView_Preview()
}
