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
                        .toolbar(.hidden, for: .tabBar)

                } label: {
                    Text("Single Prayer")
                }
                
                NavigationLink {
                    AddPrayerName(prayerType: PrayerEnum.series)
                        .toolbar(.hidden, for: .tabBar)

                } label: {
                    Text("Series Prayer")
                }

                NavigationLink {
                    AddPrayerName(prayerType: PrayerEnum.rosary)
                        .toolbar(.hidden, for: .tabBar)

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
        .modelContainer(for: PrayerSwiftDataItem.self, inMemory: true)
}

#Preview {
    NavigationView {
        AddPrayerName(prayerType: PrayerEnum.single)
            .modelContainer(for: PrayerSwiftDataItem.self, inMemory: true)
    }
}

struct AddPrayerName: View {
        
    @State private var text = ""
    public var prayerType: PrayerEnum
    
    var body: some View {
        
        VStack {
            
            TextField(text: Binding<String>(
                get: { text },
                set: { text = $0 }
            )) {
                Text("Enter prayer name...")
            }
            .padding()
            .border(.primary, width: 1)
            .padding()
            
            Spacer()
            
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
            .frame(maxWidth: .infinity, maxHeight: 70)
            //.background(.brown)
            .padding()
            
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

