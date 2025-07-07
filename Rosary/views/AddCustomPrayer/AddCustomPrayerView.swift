//
//  AddCustomPrayerView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 22/06/2025.
//

import SwiftUI
import SwiftData

struct AddCustomPrayerView: View {
    
    @State private var selection: Int = 1;
    
    var body: some View {
        NavigationView {
            List {
                
                NavigationLink {
                    AddPrayerName(prayerType: PrayerEnum.single)

                } label: {
                    Text("Single Prayer")
                }
                
                NavigationLink {
                    AddPrayerName(prayerType: PrayerEnum.series)

                } label: {
                    Text("Series Prayer")
                }

                NavigationLink {
                    AddPrayerName(prayerType: PrayerEnum.rosary)

                } label: {
                    Text("Rosary Prayer")
                }

            }
            .navigationTitle("Add custom prayer")
        }
    }
}

#Preview {
    AddCustomPrayerView()
        .environmentObject(GlobalSettings())
        .modelContainer(for: PrayerSwiftDataItem.self, inMemory: true)
}

#Preview {
    NavigationView {
        AddPrayerName(prayerType: PrayerEnum.single)
            .environmentObject(GlobalSettings())
            .modelContainer(for: PrayerSwiftDataItem.self, inMemory: true)
    }
}

struct AddPrayerName: View {
        
    @State private var text = ""
    public var prayerType: PrayerEnum
    @State private var isPresented = false
    
    var body: some View {
        
            VStack {
                
                TextField(text: Binding<String>(
                    get: { text },
                    set: { text = $0 }
                )) {
                    Text("Enter prayer name...")
                }
                .submitLabel(.done)
                .onSubmit {
                    if !text.isEmpty {
                        isPresented.toggle()
                    }
                }
                .padding()
                .border(.primary, width: 1)
                .padding()
                
                Spacer()
                                
            }
            .navigationDestination(isPresented: $isPresented) {
                                
                switch prayerType {
                case .series: AddCustomSeriesPrayer(prayerTitle: text, onSave: { ctx, p in
                    save(modelContext: ctx, prayerTitle: text, prayers: p)
                }).navigationBarBackButtonHidden(true)
                case .rosary: AddCustomRosaryV2(prayerTitle: text).navigationBarBackButtonHidden(true)
                case .single: AddCustomSinglePrayer(prayerTitle: text)
                case .bead: EmptyView()
                }
                            
        } .toolbar {
            ToolbarItem(
                placement: ToolbarItemPlacement.topBarTrailing) {
                    
                    NavigationLink {
                        
                        if prayerType == .series {
                            AddCustomSeriesPrayer(prayerTitle: text, onSave: { ctx, p in
                                save(modelContext: ctx, prayerTitle: text, prayers: p)
                            })
                            .navigationBarBackButtonHidden(true)
                        }
                        
                        if prayerType == .rosary {
                            
                            AddCustomRosaryV2(prayerTitle: text)
                                .navigationBarBackButtonHidden(true)
                        }
                        
                        if prayerType == .single {
                            AddCustomSinglePrayer(prayerTitle: text)
                        }
                        
                    } label: {
                        Text("Next")
                    }
                    .disabled(text.isEmpty)
                    
                }
        }

    }
    
    func save(
        modelContext: ModelContext,
        prayerTitle: String,
        prayers: [Prayer]
    ) {
        do {
            
            let customPrayer = CustomPrayer(
                name: prayerTitle,
                orderIndex: 0,
                prayerSwiftDataItems: []
            )
            
            var _prayers: [PrayerSwiftDataItem] = []
            
            for _prayer in prayers {
                let prayer = PrayerSwiftDataItem(
                    name: _prayer.name,
                    data: _prayer.data,
                    orderIndex: 0,
                    customPrayer: customPrayer
                )
                prayer.id = _prayer.id
                
                _prayers += [prayer]
                
                // modelContext.insert(prayer)
            }
            customPrayer.prayerSwiftDataItems = _prayers
            
            modelContext.insert(customPrayer)
            
            try modelContext.save()
            
        } catch {
            print(error)
        }
    }
        
}

