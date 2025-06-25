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
    @State var prayers: [Prayer] = [];
    @State private var sheetIsPresented: Bool = false
    @State private var sheetPrayerTitleIsPresented = false
    @Query var prayerSwiftDataItems: [PrayerSwiftDataItem]
    private var rosaryPrayers = PrayerData.prayers + RosaryMystery.all()
    
    @State var searchText = ""
    @State public var prayerTitle: String
    
    var filteredPrayers: [Prayer] {
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
            ListPrayers(prayers: $prayers)
                .toolbar {
                    
                    ToolbarItem(
                        placement: ToolbarItemPlacement.topBarLeading) {
                            Text(prayerTitle)
                        }
                    
                    ToolbarItem(
                        placement: ToolbarItemPlacement.topBarTrailing) {
                            HStack {
                                Button("Set Rosary Title") {
                                    sheetPrayerTitleIsPresented.toggle()
                                }

                                Menu {
                                    Button("Add Prayer") {
                                        sheetIsPresented.toggle()
                                    }
                                    
                                    Button("Clear All") {
                                        prayers = []
                                    }.disabled(prayers.isEmpty)
                                } label: {
                                    Image(systemName: "ellipsis")
                                }
                                
                            }
                            
                        }
                }
            
            Spacer()
            Button("Save") {
                save()
            }.disabled(prayers.isEmpty)
            
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
                            nextOrderIndex: 0,//(prayers.map { $0.orderIndex }.max() ?? -1) + 1,
                            addItem: addItem
                        )
                    }
                }.listStyle(.plain)
            }
        }
        .sheet(isPresented: Binding<Bool>(
            get: { sheetPrayerTitleIsPresented},
            set: { if $0 { sheetPrayerTitleIsPresented = $0 } }
        ), content: {
            VStack {
                HStack {
                    Text("Set Rosary title")
                        .font(.system(.title, design: .rounded))
                        .bold()
                    Spacer()
                    Button {
                        sheetPrayerTitleIsPresented = false
                    } label: {
                        Image(systemName: "xmark").font(.headline)
                    }
                }.padding()
                Divider().padding(.bottom)
                
                TextField("Type your rosary title here...", text: $prayerTitle)
                    .frame(height: 50.0)
                    .padding(.horizontal)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                
                Button(action: {
                }) {
                    Text("Save")
                        .font(.system(.headline, design: .rounded))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                .padding(.bottom)
                Spacer()

            }.padding()
        })
        .searchable(text: $searchText)

    }
    
    func addItem(prayer: Prayer) {
        prayers += [prayer]
    }
    
    func save() {
        
        let customPrayer = CustomPrayer(
            name: prayerTitle,
            orderIndex: 0,
            prayerSwiftDataItems: []
        )
        
        for prayer in prayers {
            let prayer = PrayerSwiftDataItem(
                name: prayer.name,
                data: prayer.data,
                orderIndex: 0,
                customPrayer: customPrayer
            )
            
            modelContext.insert(prayer)
        }

        modelContext.insert(customPrayer)

    }
    
}

struct PrayerItem: View {
    
    public var prayer: Prayer;
    public var nextOrderIndex: Int
    public var addItem: (_: Prayer) -> Void;

    var body: some View {
        Button {
            addItem(prayer)
        } label: {
            
            HStack {
                Text(prayer.name)
                Spacer()
            }
            
        }.padding(10)
    }
    
}

struct ListPrayers: View {
    
    @Environment(\.modelContext) private var modelContext;
    @Binding var prayers: [Prayer]
    @State private var prayersSorted: [Prayer] = []
    
    var body: some View {
        List {
            
            ForEach(prayers) { prayer in
                HStack {
                    Text(prayer.name)
                    Spacer()
                    
                }
                .padding(10)
            }
            .onDelete { indexSet in
                deleteItems(offsets: indexSet)
            }
            .onMove(perform: move)
            
        }
        .listStyle(.plain)
        .onAppear {
            prayersSorted = prayers
        }
        .toolbar {
            EditButton().disabled(prayers.isEmpty)
        }
        
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            prayers.remove(atOffsets: offsets)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        print(source, destination)
        prayers.move(fromOffsets: source, toOffset: destination)
    }
    
}

#Preview {
    AddCustomRosary( prayerTitle: "Title")
        .modelContainer(for: PrayerSwiftDataItem.self, inMemory: true)
}
