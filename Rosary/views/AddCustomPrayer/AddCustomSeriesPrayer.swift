//
//  AddCustomSeriesPrayer.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/06/2025.
//

import SwiftUI
import SwiftData

struct AddCustomSeriesPrayer: View {
    
    @Environment(\.dismiss) private var dismiss;
    @Environment(\.modelContext) private var modelContext;
    @State var prayers: [Prayer] = [];
    @State private var sheetIsPresented: Bool = false
    @State private var sheetPrayerTitleIsPresented = false
    @Query var prayerSwiftDataItems: [PrayerSwiftDataItem]
    
    @State var searchText = ""
    @State public var prayerTitle: String
    public var onSave: (
        _ context: ModelContext,
        _ prayers: [Prayer]
    ) -> Void
    
    var filteredPrayers: [Prayer] {
        if searchText.isEmpty {
            return prayers
        } else {
            return prayers.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    init(prayerTitle: String, onSave: @escaping (
        _ context: ModelContext,
        _ prayers: [Prayer]
    ) -> Void) {
        self.prayerTitle = prayerTitle
        self.onSave = onSave
    }
    
    var body: some View {
        
        NavigationStack {
            
            if prayers.isEmpty {
                Text("No prayers.")
                    .font(.callout)
                    .padding(.bottom)
                Button("Click to add prayers") {
                    sheetIsPresented = true
                }
            } 
            
            ListPrayers(prayers: $prayers)
                .toolbar {
                    
                    ToolbarItem(
                        placement: ToolbarItemPlacement.topBarLeading) {
                            HStack {
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "chevron.left")
                                }
                                Text(prayerTitle)
                            }
                        }
                    
                    ToolbarItem(
                        placement: ToolbarItemPlacement.topBarTrailing) {
                            HStack {
                                Button("Set Title") {
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
                onSave(modelContext, prayers)
            }.disabled(prayers.isEmpty)
        
            
        }
        .sheet(isPresented: $sheetIsPresented) {
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
                
                ListPrayersBottomSheet(
                    allPrayers: PrayerData.loadPrayers(using: modelContext),
                    addItem: addItem
                )
                
            }
        }
        .sheet(isPresented: Binding<Bool>(
            get: { sheetPrayerTitleIsPresented},
            set: { if $0 { sheetPrayerTitleIsPresented = $0 } }
        ), content: {
            VStack {
                HStack {
                    Text("Set title")
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
                
                TextField("Type your title here...", text: $prayerTitle)
                    .frame(height: 50.0)
                    .padding(.horizontal)
                    .background(Color(.systemGray2))
                    .cornerRadius(5)
                
                Button(action: {
                    sheetPrayerTitleIsPresented.toggle()
                }) {
                    Text("Done")
                        .font(.system(.headline, design: .rounded))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                    //.foregroundStyle(Color.secondary)
                    //.background(Color.primary)
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
}

struct ListPrayersBottomSheet: View {
    
    @State public var allPrayers: [Prayer]
    public var addItem: (_ prayer: Prayer) -> Void
    
    var body: some View {
        List {
            ForEach(allPrayers) { prayer in
                PrayerItem(
                    prayer: prayer,
                    nextOrderIndex: 0,//(prayers.map { $0.orderIndex }.max() ?? -1) + 1,
                    addItem: addItem
                )
            }
        }.listStyle(.plain)

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
    AddCustomSeriesPrayer(prayerTitle: "Divine Mercy", onSave: { context, prayers in
        print(context, prayers)
    })
        .modelContainer(for: PrayerSwiftDataItem.self, inMemory: true)
}
