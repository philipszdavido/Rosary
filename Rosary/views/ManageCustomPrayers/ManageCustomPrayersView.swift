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
    
    var filterPrayerSwiftDataItems: [PrayerSwiftDataItem] {
        if searchText.isEmpty {
            return prayerSwiftDataItems
        }
        return prayerSwiftDataItems.filter({ prayerSwiftDataItem in
            prayerSwiftDataItem.name
                .lowercased()
                .contains(searchText.lowercased())
        })
    }
    
    var body: some View {
        NavigationView {
            List {

                Section("All Custom Prayers") {

                    if filter.isEmpty {
                        EmptyUIView()
                            .listRowSeparator(.hidden)
                    }

                    ForEach(filter) { customPrayer in
                        
                        NavigationLink {
                            
                            NavLink(customPrayer: customPrayer)
                            
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
                    
                    if filterPrayerSwiftDataItems.isEmpty {
                        EmptyUIView()
                            .listRowSeparator(.hidden)
                    }

                    ForEach(filterPrayerSwiftDataItems) { p in
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
                prayers: [
                    PrayerData.hailMaryPrayer(),
                    PrayerData.gloryBePrayer(.bead)
                ],
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

struct NavLink: View {
    
    public var customPrayer: CustomPrayer
    
    var body: some View {
            
            if customPrayer.isRosary {
                
                AddCustomRosaryV2(
                    prayerTitle: customPrayer.name,
                    prayerSections: convertToSections(prayerSwiftDataItems: customPrayer.prayerSwiftDataItems)
                ).navigationBarBackButtonHidden()
                
            } else {
                
                ListCustomPrayerPrayerItems(customPrayer: customPrayer)
            }

    }
    
    func convertToSections(prayerSwiftDataItems: [PrayerSwiftDataItem]) -> [PrayerSection] {
        var sectionMap: [UUID: PrayerSection] = [:]

        for (index, item) in prayerSwiftDataItems.enumerated() {
            let prayer = Prayer(from: item)
            let sectionType: PrayerSectionType = item.type == .bead ? .decade : .normal

            if let sectionId = item.sectionId {
                if var section = sectionMap[sectionId] {
                    section.prayers.append(prayer)
                    sectionMap[sectionId] = section  // ✅ Must reassign due to struct value semantics
                } else {
                    let newSection = PrayerSection(
                        id: sectionId,
                        name: item.name, // Or "\(index)" if you want index-based names
                        type: sectionType,
                        prayers: [prayer]
                    )
                    sectionMap[sectionId] = newSection
                }
            } else {
                let newId = UUID()
                let standaloneSection = PrayerSection(
                    id: newId,
                    name: item.name,
                    type: sectionType,
                    prayers: [prayer]
                )
                sectionMap[newId] = standaloneSection
            }
        }

        return Array(sectionMap.values)
    }
    
}

#Preview {
            
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            ManageCustomPrayersView().tabItem { Text("Manage Custom Prayers") }.tag(1)
            AddCustomPrayerView().tabItem { Text("Add Custom Prayer") }.tag(2)
        }
        .environmentObject(GlobalSettings())
        .modelContainer(for: PrayerSwiftDataItem.self, inMemory: true)
        .modelContainer(for: CustomPrayer.self, inMemory: true)
}
