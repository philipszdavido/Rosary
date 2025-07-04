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
    @Query(
        filter: #Predicate<PrayerSwiftDataItem>{ $0.customPrayer == nil }
    ) var prayerSwiftDataItems: [PrayerSwiftDataItem]
    @State var searchText = ""
    
    var filter: [CustomPrayer] {
        if searchText.isEmpty {
            return customPrayers
        }
        return customPrayers.filter({ CustomPrayer in
            CustomPrayer.name
                .lowercased()
                .contains(searchText.lowercased())
        })
    }
    
    var body: some View {
        NavigationView {
            List {
                if filter.isEmpty {
                    EmptyUIView()
                        .listRowSeparator(.hidden)
                }

                Section("All Custom Prayers") {
                    
                    ForEach(filter) { customPrayer in
                        NavigationLink {
                            ListCustomPrayerPrayerItems(customPrayer: customPrayer)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(customPrayer.name)
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .onDelete { indexSet in
                        withAnimation {
                            for index in indexSet {
                                PrayerData
                                    .deleteCustomPrayer(
                                        modelContext: modelContext,
                                        customPrayer: customPrayers[index]
                                    )
                            }
                        }
                    }
                }
                
                Section("All Single prayers") {
                    
                    if prayerSwiftDataItems.isEmpty {
                        EmptyUIView()
                            .listRowSeparator(.hidden)
                    }

                    ForEach(prayerSwiftDataItems) { p in
                        VStack(alignment: .leading) {
                            Text(p.name)
                            if let p = p.customPrayer {
                                Text("\(p.id)")
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            modelContext.delete(prayerSwiftDataItems[index])
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(
                    placement: ToolbarItemPlacement.topBarTrailing) {
                        EditButton()
                    }
            }
            .searchable(text: $searchText)
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
