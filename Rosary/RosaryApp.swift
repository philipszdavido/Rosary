//
//  RosaryApp.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import SwiftUI
import SwiftData

@main
struct RosaryApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PrayerSwiftDataItem.self,
            CustomPrayer.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject var settings = GlobalSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .preferredColorScheme(settings.theme == .dark ? .dark : .light)
        }
        .modelContainer(sharedModelContainer)
    }
}
