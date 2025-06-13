//
//  PrayersViewV2.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 12/06/2025.
//

import SwiftUI

struct PrayersViewV2: View {
    
    @State var prayers = PrayerData.prayers;
    @State var rosary: Prayer = Prayer(
        name: "Rosary",
        type: PrayerEnum.rosary,
        data: ""
    )
    
    @State var quickPrayers = PrayerData.prayers as [Prayer];
        
    var body: some View {
        List {
            
            // Header Section
            Section {
                VStack(alignment: .leading) {
                    Text(formattedToday())
                        .foregroundStyle(Color.gray.opacity(0.7))
                    Text("Today")
                        .font(.system(size: 34, weight: .heavy))
                }
                .padding(.horizontal)
            }
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .padding(.bottom)

            // Rosary Navigation Card
            RosaryNavigationCard(rosary: $rosary)

            // Horizontal ScrollView Section
            HorizontalScrollViewSection(quickPrayers: $quickPrayers)

            // List of prayers
            Section {
                ForEach($prayers) { $prayer in
                    NavigationLink {
                        switch prayer.type {
                        case .rosary:
                            RosaryView(prayer: $prayer)
                                .toolbar(.hidden, for: .tabBar)
                                .navigationBarBackButtonHidden(true)
                        case .single:
                            SinglePrayerView(prayer: $prayer)
                                .toolbar(.hidden, for: .tabBar)
                                .navigationBarBackButtonHidden(true)
                        }

                    } label: {
                        Text(prayer.name)
                            .padding(.vertical, 8)
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }
        .listStyle(.plain)
    }

    func addItem() {
        
    }
    
    func deleteItems(offsets: IndexSet) {
        
    }
    
}

#Preview {
    NavigationStack {
        PrayersViewV2()
    }
}


struct HorizontalScrollViewSection: View {

    @Binding var quickPrayers: [Prayer]

    var body: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach($quickPrayers) { $quickPrayer in
                        if $quickPrayer.wrappedValue.name != "Rosary" {
                            ZStack {
                                
                                NavigationLink (
                                    destination: SinglePrayerView(
                                        prayer: $quickPrayer
                                    )
                                    .toolbar(.hidden, for: .tabBar)
                                    .navigationBarBackButtonHidden(true)
                                ) {
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(randomColor)
                                        .frame(width: 150, height: 90)
                                        .overlay {
                                            VStack {
                                                Text(quickPrayer.name)
                                                    .fontWeight(.bold)
                                                    .multilineTextAlignment(.center)
                                                    .foregroundStyle(.white)
                                                    .font(.system(size: 15, weight: .medium))
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .padding(.top, 20)
    }
}

struct RosaryNavigationCard: View {
    
    @Binding var rosary: Prayer
    
    var body: some View {
        Section {
            ZStack {
                
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(Color.blue)
                    .frame(height: 150)
                    .overlay {
                        VStack(alignment: .center) {
                            Text("Say Rosary")
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .font(.system(size: 44, weight: .medium))
                            Text(RosaryMystery.today().rawValue)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .font(.system(size: 24, weight: .medium))
                        }
                    }

                NavigationLink(
                    destination: RosaryView(prayer: $rosary).toolbar(.hidden, for: .tabBar)
                        .navigationBarBackButtonHidden(true)
                ) {
                    EmptyView()
                }
                .listRowInsets(EdgeInsets())
                .padding(.horizontal)
                .opacity(0)
            }
        }.listRowSeparator(.hidden)

    }
}
