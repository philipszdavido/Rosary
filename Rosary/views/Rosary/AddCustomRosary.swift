//
//  AddCustomRosary.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 19/06/2025.
//

import SwiftUI

struct AddCustomRosary: View {
    
    @State private var prayers: [Prayer] = RosaryUtils().constructRosary();
    @State private var sheetIsPresented: Bool = false
    private var rosaryPrayers = PrayerData.prayers
    
    @State var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ListPrayers(prayers: $prayers)
            }.listStyle(.plain)
                .toolbar {
                    ToolbarItem(
                        placement: ToolbarItemPlacement.topBarTrailing) {
                            Button("Add Prayer") {
                                sheetIsPresented.toggle()
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
                            prayers += [prayer]
                        }
                    }
                }.listStyle(.plain)
            }
        }
        .searchable(text: $searchText)

    }
}

struct ListPrayers: View {
    @Binding public var prayers: [Prayer]
    
    var body: some View {
        ForEach(prayers) { prayer in
            HStack {
                Text(prayer.name)
                Spacer()
                
                Button {
                } label: {
                    Image(systemName: "trash")
                }

            }
        }
    }
}

#Preview {
    AddCustomRosary()
}
