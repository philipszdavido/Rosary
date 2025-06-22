//
//  AddCustomRosary.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 19/06/2025.
//

import SwiftUI
import SwiftData

struct AddCustomRosary: View {
    
    @Environment(\.modelContext) private var modelContext;
    @Query var prayers: [PrayerSwiftDataItem];
    @State private var sheetIsPresented: Bool = false
    private var rosaryPrayers = PrayerData.prayers + RosaryMystery.all()
    
    @State var searchText = ""
    
    var filteredPrayers: [PrayerSwiftDataItem] {
        if searchText.isEmpty {
            return prayers
        } else {
            return prayers.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ListPrayers(prayers: filteredPrayers)
            }.listStyle(.plain)
                .toolbar {
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
                        HStack {
                            Text(prayer.name)
                            Spacer()
                        }.onTapGesture {
                            addItem(prayer.data, prayer.name)
                        }.padding(10)
                    }
                }.listStyle(.plain)
            }
        }
        .searchable(text: $searchText)

    }
    
    private func addItem(_ data: String, _ title: String) {
        withAnimation {
            let newItem = PrayerSwiftDataItem(data: data, name: title)
            modelContext.insert(newItem)
        }
    }

}

struct ListPrayers: View {
    
    @Environment(\.modelContext) private var modelContext;
    public var prayers: [PrayerSwiftDataItem]
    
    var body: some View {
        ForEach(prayers) { prayer in
            HStack {
                Text(prayer.name)
                Spacer()
                
            }.padding(10)
        }.onDelete { indexSet in
            print(indexSet)
            deleteItems(offsets: indexSet)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(prayers[index])
            }
        }
    }

}

#Preview {
    AddCustomRosary()
        .modelContainer(for: PrayerSwiftDataItem.self, inMemory: true)
}
