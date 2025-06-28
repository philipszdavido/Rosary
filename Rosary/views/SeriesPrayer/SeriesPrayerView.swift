//
//  SeriesPrayerView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 21/06/2025.
//

import SwiftUI
import SwiftData

struct SeriesPrayerView: View {
    
    @Binding var prayer: Prayer
    @Environment(\.modelContext) var modelContext
    var prayers: [PrayerSwiftDataItem] = []
    
    var body: some View {
        
        List {
            ForEach(
                loadPrayers(using: modelContext, prayer: prayer)
            ) { prayer in
                Text(prayer.name)
            }
        }.listStyle(.plain)
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
    }
        
}

#Preview {
    SeriesPrayerView(prayer: Binding<Prayer>(
        get: {Prayer(name: "", type: .single, data: "")},
        set: { _ in}
    )).modelContainer(
        for: [PrayerSwiftDataItem.self, CustomPrayer.self],
        inMemory: true
    ).environmentObject(GlobalSettings())
}

#Preview {
    NavigationStack {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            PrayersViewV2().tabItem { Text("Prayers") }.tag(1)
            AddCustomPrayerView().tabItem { Text("Add Custom Prayer") }.tag(2)
        }
    }.modelContainer(
        for: [PrayerSwiftDataItem.self, CustomPrayer.self],
        inMemory: true
    ).environmentObject(GlobalSettings())
}


func loadPrayers(using context: ModelContext, prayer: Prayer) -> [Prayer] {
    
    var prayers: [Prayer] = []
    
    do {
        let descriptor = FetchDescriptor<CustomPrayer>(
            predicate: #Predicate { $0.id == prayer.id },
            sortBy: [SortDescriptor(\.orderIndex)]
        )
        
        let allPrayers = try context.fetch(descriptor)
        
        guard let foundPrayer = allPrayers.first else { return prayers }
        
        prayers = foundPrayer.prayerSwiftDataItems.map { PrayerSwiftDataItem in
            Prayer(from: PrayerSwiftDataItem)
        }

    } catch {
        print("Error fetching prayers: \(error)")
    }
    
    return prayers
}
