//
//  ContentView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var selectedTab: Int = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            
            PrayersViewV2()
            .tabItem {
                Image(systemName: "book.pages")
                Text("Prayers")
            }
            .tag(1)
            
            AddCustomRosary()
                .tabItem {
                    Image(systemName: "plus.app")
                    Text("Add Custom Rosary")
                }.tag(2)
            
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(3)
            
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
        .environmentObject(GlobalSettings())
}
