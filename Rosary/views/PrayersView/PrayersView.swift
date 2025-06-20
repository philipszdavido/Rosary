//
//  PrayersView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import SwiftUI

struct PrayersView: View {
    
    @State var prayers = PrayerData.prayers;

    var body: some View {
        NavigationView {
            List {
                ForEach($prayers) { $prayer in
                    NavigationLink {

                        switch prayer.type {
                        case .rosary:
                            RosaryView(prayer: $prayer)
                        case .single:
                            SinglePrayerView(prayer: $prayer)
                        case .bead:
                            EmptyView()
                        }
                        
                    } label: {
                        Text(prayer.name)
                    }
                    .padding(.horizontal)
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Prayers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }.onAppear {
        }
    }
    
    func addItem() {
        
    }
    
    func deleteItems(offsets: IndexSet) {
        
    }
}



#Preview {
    PrayersView()
}
