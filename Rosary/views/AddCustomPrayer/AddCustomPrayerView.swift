//
//  AddCustomPrayerView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 22/06/2025.
//

import SwiftUI

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
                
            }
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
                    AddCustomSeriesPrayer(prayerTitle: text)
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
        
}
