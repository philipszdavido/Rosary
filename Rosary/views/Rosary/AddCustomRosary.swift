//
//  AddCustomRosary.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 19/06/2025.
//

import SwiftUI
import SwiftData


struct AddCustomRosary: View {

    @State public var prayerTitle: String
    @Environment(\.modelContext) var modelContext

    var body: some View {
        AddCustomSeriesPrayer(prayerTitle: prayerTitle, onSave: { contxt, p in
            save(modelContext: contxt, prayerTitle: prayerTitle, prayers: p)
        })
    }
    
    func save(
        modelContext: ModelContext,
        prayerTitle: String,
        prayers: [Prayer]
    ) {
        
        var customPrayer = CustomPrayer(
            name: prayerTitle,
            orderIndex: 0,
            prayerSwiftDataItems: []
        )
        
        customPrayer.isRosary = true
        
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


#Preview {
    AddCustomRosary( prayerTitle: "Title")
        .modelContainer(for: PrayerSwiftDataItem.self, inMemory: true)
}
