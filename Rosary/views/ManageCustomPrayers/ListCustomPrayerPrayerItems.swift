//
//  ListCustomPrayerPrayerItems.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 04/07/2025.
//

import SwiftUI
import SwiftData

struct ListCustomPrayerPrayerItems: View {
    
    var customPrayer: CustomPrayer
    @State var prayers: [PrayerSwiftDataItem] = []
    @Environment(\.modelContext) var modelContext
    @State var show = false
    @State var searchText = ""
    
    var filter: [PrayerSwiftDataItem] {
        if searchText.isEmpty {
            return customPrayer.prayerSwiftDataItems
        }
        return customPrayer.prayerSwiftDataItems.filter({ PrayerSwiftDataItem in
            PrayerSwiftDataItem.name
                .lowercased()
                .contains(searchText.lowercased())
        })
    }

    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                Text(customPrayer.name)
                    .font(.title)
            }.padding(.horizontal)
            
            List {
                Section("Prayers") {
                    
                    if filter.isEmpty {
                        EmptyUIView()
                    }
                    
                    ForEach(filter) { prayer in
                        NavigationLink(destination: EditPrayerSwiftDataItemView(item: prayer)) {
                            VStack(alignment: .leading) {
                                Text(prayer.name)
//                                Text("\(prayer.id)")
//                                    .font(.caption)
//                                    .foregroundColor(.secondary)
                                Text("\(prayer.type)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete { IndexSet in
                        withAnimation {
                            for index in IndexSet {
                                modelContext.delete(customPrayer.prayerSwiftDataItems[index])
                            }
                        }
                    }
                }
            }.listStyle(.plain)
                .searchable(text: $searchText)
        }
        .toolbar {
            ToolbarItem(
                placement: ToolbarItemPlacement.topBarTrailing) {
                    HStack {
                        Button("Edit") {
                            show.toggle()
                        }

                        Button("Delete") {
                            
                            PrayerData
                                .deleteCustomPrayer(
                                    modelContext: modelContext,
                                    customPrayer: customPrayer
                                )
                            
                            // modelContext.delete(customPrayer)
                            
                        }
                    }
                }
        }
        .sheet(isPresented: $show, onDismiss: {
            
        }, content: {
                EditCustomPrayerView(customPrayer: customPrayer)
        })
        .onAppear {
            prayers = customPrayer.prayerSwiftDataItems
        }
    }
}

#Preview {
    ListCustomPrayerPrayerItems(
        customPrayer: CustomPrayer(
            name: "",
            orderIndex: 0,
            prayerSwiftDataItems: []
        )
    )
}
