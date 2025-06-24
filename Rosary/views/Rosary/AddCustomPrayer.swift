//
//  AddCustomRosary.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 19/06/2025.
//

import SwiftUI
import SwiftData

struct AddCustomPrayer: View {
    
    @Environment(\.modelContext) private var modelContext;
    @Query var prayers: [PrayerSwiftDataItem];
    @State private var sheetIsPresented: Bool = false
    private var rosaryPrayers = PrayerData.prayers + RosaryMystery.all()
    
    @State var searchText = ""
    public var prayerTitle: String
    
    var filteredPrayers: [PrayerSwiftDataItem] {
        if searchText.isEmpty {
            return prayers
        } else {
            return prayers.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    init(prayerTitle: String) {
        self.prayerTitle = prayerTitle
    }
    
    var body: some View {
        NavigationStack {
            ListPrayers(prayers: prayers)
                .toolbar {
                    
                    ToolbarItem(
                        placement: ToolbarItemPlacement.topBarLeading) {
                            Text(prayerTitle)
                        }
                    
                    ToolbarItem(
                        placement: ToolbarItemPlacement.topBarTrailing) {
                            HStack {
                                Button("Add Prayer") {
                                    sheetIsPresented.toggle()
                                }
                                
                                Button("Clear All") {
                                    
                                    
                                    for index in prayers.indices {
                                        modelContext.delete(prayers[index])
                                    }
                                    
                                }
                            }
                            
                        }
                }
            
        }.sheet(isPresented: $sheetIsPresented) {
            
        } content: {
            VStack {
                HStack {
                    Text("Select Prayer").font(.headline)
                    Spacer()
                    Button("Done") {
                        sheetIsPresented.toggle()
                    }
                }.padding(.horizontal)
                    .padding(.top, 19)
                    .padding(.bottom, 19)
                
                List {
                    ForEach(rosaryPrayers) { prayer in
                        PrayerItem(
                            prayer: prayer,
                            nextOrderIndex: (prayers.map { $0.orderIndex }.max() ?? -1) + 1
                            )
                    }
                }.listStyle(.plain)
            }
        }
        .searchable(text: $searchText)

    }
    
}

struct PrayerItem: View {
    
    public var prayer: Prayer;
    @Environment(\.modelContext) private var modelContext;
    @State var clicked = false
    public var nextOrderIndex: Int

    var body: some View {
        HStack {
            Text(prayer.name)
            Spacer()
            
            if clicked {
                Image(systemName: "checkmark")
            }
            
        }.onTapGesture {
            clicked.toggle()
            addItem(prayer.data, prayer.name)
        }.padding(10)
    }
    
    private func addItem(_ data: String, _ title: String) {
        withAnimation {
//            let newItem = PrayerSwiftDataItem(
//                name: title, data: data,
//                orderIndex: nextOrderIndex
//            )
//            modelContext.insert(newItem)
        }
    }

}

struct ListPrayers: View {
    
    @Environment(\.modelContext) private var modelContext;
    var prayers: [PrayerSwiftDataItem]
    @State private var prayersSorted: [PrayerSwiftDataItem] = []

    var body: some View {
        List {
            
            ForEach(prayers) { prayer in
                HStack {
                    Text(prayer.name)
                    Spacer()
                    
                }.padding(10)
            }.onDelete { indexSet in
                print(indexSet)
                deleteItems(offsets: indexSet)
            }.onMove(perform: move)
        }.listStyle(.plain)
            .onAppear {
                prayersSorted = prayers
            }
            .toolbar {
                EditButton()
            }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(prayers[index])
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        print(source, destination)
        prayersSorted.move(fromOffsets: source, toOffset: destination)

        for (index, prayer) in prayersSorted.enumerated() {
            prayer.orderIndex = index
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to save reordered items: \(error.localizedDescription)")
        }
    }
    
}

#Preview {
    AddCustomPrayer( prayerTitle: "Title")
        .modelContainer(for: PrayerSwiftDataItem.self, inMemory: true)
}
