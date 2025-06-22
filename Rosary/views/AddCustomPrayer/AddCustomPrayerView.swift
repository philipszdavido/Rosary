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
                    AddCustomSinglePrayer()
                } label: {
                    Text("Single Prayer")
                }
                
                NavigationLink {
                    AddCustomPrayer()
                    
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
