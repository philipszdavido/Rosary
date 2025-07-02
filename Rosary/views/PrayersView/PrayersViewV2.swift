//
//  PrayersViewV2.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 12/06/2025.
//

import SwiftUI
import SwiftData

struct PrayersViewV2: View {
    
    @State var prayers: [Prayer] = []
    @State var rosary: Prayer = Prayer(
        name: "Rosary",
        type: PrayerEnum.rosary,
        data: ""
    )
    
    @State var quickPrayers = PrayerData.quickPrayers as [Prayer];
    @Query(filter: #Predicate<PrayerSwiftDataItem> { $0.customPrayer == nil }) var customPrayers: [PrayerSwiftDataItem]
    @Query var customSeriesPrayers: [CustomPrayer]
        
    var body: some View {
        NavigationStack {
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
                Section("All Prayers") {
                    ForEach($prayers) { $prayer in
                        NavigationLink {
                            switch prayer.type {
                            case .rosary:
                                RosaryView2(prayer: $prayer)
                                    .toolbar(.hidden, for: .tabBar)
                                    .navigationBarBackButtonHidden(true)
                            case .single:
                                SinglePrayerView(prayer: $prayer)
                                    .toolbar(.hidden, for: .tabBar)
                                    .navigationBarBackButtonHidden(true)
                            case .series:
                                SeriesPrayerView(prayer: $prayer)
                            case .bead:
                                EmptyView()
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
        }.onAppear {
            _init()
        }
    }
    
    func _init() {
        
        prayers = customSeriesPrayers.map { Prayer(from: $0) } +
                  customPrayers.map { Prayer(from: $0) } + PrayerData.prayers
    }

    func addItem() {
        
    }
    
    func deleteItems(offsets: IndexSet) {
        
    }
    
}

#Preview {
    NavigationStack {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            PrayersViewV2().tabItem {
                Image(systemName: "hands.and.sparkles")
                Text("Prayers") }.tag(1)
            AddCustomPrayerView().tabItem {
                Image(systemName: "plus.app")
                Text("Add Custom Prayer")
            }.tag(2)
        }
    }.modelContainer(
        for: [PrayerSwiftDataItem.self, CustomPrayer.self],
        inMemory: true
    ).environmentObject(GlobalSettings())
}

#Preview {
    PrayersViewV2()
}

struct CustomPrayers: View {
    
    public var customPrayers: [PrayerSwiftDataItem]
    
    var body: some View {
        Section("Custom Prayers") {
            ForEach(customPrayers) { prayer in
                Text(prayer.name)
            }
        }
    }
}

struct HorizontalScrollViewSection: View {

    @Binding var quickPrayers: [Prayer]

    var body: some View {
        Section("Quick Prayers") {
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
            }
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .padding(.horizontal)
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
