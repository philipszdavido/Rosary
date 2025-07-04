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

    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                Text(customPrayer.name)
                    .font(.title)
            }.padding(.horizontal)
            
            List {
                Section("Prayers") {
                    ForEach(customPrayer.prayerSwiftDataItems) { prayer in
                        NavigationLink(destination: EditPrayerSwiftDataItemView(item: prayer)) {
                            VStack(alignment: .leading) {
                                Text(prayer.name)
                                Text("\(prayer.id)")
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
        }
        .toolbar {
            ToolbarItem(
                placement: ToolbarItemPlacement.topBarTrailing) {
                    HStack {
                        Button("Edit") {
                            show.toggle()
                        }

                        Button("Delete") {
                            
                            modelContext.delete(customPrayer)
                            
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
