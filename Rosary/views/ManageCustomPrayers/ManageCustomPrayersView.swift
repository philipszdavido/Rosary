//
//  ManageCustomPrayersView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 02/07/2025.
//

import SwiftUI
import SwiftData

struct ManageCustomPrayersView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var customPrayers: [CustomPrayer]
    @Query var prayerSwiftDataItems: [PrayerSwiftDataItem]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(customPrayers) { customPrayer in
                    
                    NavigationLink {
                        ListCustomPrayerPrayerItems(customPrayer: customPrayer)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(customPrayer.name)
                            Text("\(customPrayer.id)")
                            Text(customPrayer.isRosary ? " (Rosary)" : "")
                        }
                    }
                    
                }.onDelete { IndexSet in
                    withAnimation {
                        for index in IndexSet {
                            modelContext.delete(customPrayers[index])
                        }
                    }
                }
                
//                Section("All prayers") {
//                    ForEach(prayerSwiftDataItems) { p in
//                        VStack(alignment: .leading) {
//                            Text(p.name)
//                            if let p = p.customPrayer {
//                                Text("\(p.id)")
//                            }
//                        }
//                    }.onDelete { IndexSet in
//                        for index in IndexSet {
//                            modelContext.delete(prayerSwiftDataItems[index])
//                        }
//                    }
//                }
                
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(
                    placement: ToolbarItemPlacement.topBarTrailing) {
                        EditButton()
                    }
            }
        }
    }
}

struct ManageCustomPrayersView_Preview: PreviewProvider {
    static var previews: some View {
        preview()
    }

    static func preview() -> some View {
        do {
            let schema = Schema([
                CustomPrayer.self,
                PrayerSwiftDataItem.self
            ])

            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true
            )

            let modelContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )

            let modelContext = ModelContext(modelContainer)

            // Seed sample data
            PrayerData.save(
                modelContext: modelContext,
                prayerTitle: "Prayer 1",
                prayers: PrayerData.quickPrayers,
                prayer: Prayer(
                    name: "Prayer 1",
                    type: PrayerEnum.series,
                    data: ""
                )
            )

            PrayerData.save(
                modelContext: modelContext,
                prayerTitle: "Novena",
                prayers: PrayerData.prayers,
                prayer: Prayer(
                    name: "Novena",
                    type: PrayerEnum.series,
                    data: ""
                )
            )

            PrayerData.save(
                modelContext: modelContext,
                prayerTitle: "Ten Decades",
                prayers: [PrayerData.hailMaryPrayer()],
                prayer: Prayer(
                    name: "Ten Decades",
                    type: PrayerEnum.rosary,
                    data: ""
                )
            )

            return AnyView(
                ManageCustomPrayersView()
                    .environmentObject(GlobalSettings())
                    .modelContext(modelContext)
            )

        } catch {
            return AnyView(
                Text("Failed to create model container: \(error.localizedDescription)")
                    .padding()
                    .foregroundColor(.red)
            )
        }
    }
    
}
