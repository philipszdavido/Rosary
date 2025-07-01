//
//  SeriesPrayerView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 21/06/2025.
//

import SwiftUI
import SwiftData

struct SeriesPrayerView: View {
    
    @Binding var prayer: Prayer
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var settings: GlobalSettings
    @Query var ps: [CustomPrayer]
    @State var prayerSequence: [Prayer] = []
    @State var prayerType = RosaryType.none
    
    @StateObject public var speaker = RosarySpeaker()
    @State var prayers = []
    
    var getPrayers: [Prayer] {
                
        let f = ps.first { CustomPrayer in
            CustomPrayer.id == prayer.id
        }
        
        guard let f = f else { return [] }
        
        return f.prayerSwiftDataItems.map { PrayerSwiftDataItem in
            Prayer(from: PrayerSwiftDataItem)
        }
        
    }
    
    var body: some View {

        VStack {

            ScrollView {
                ForEach(Array(prayerSequence.enumerated()), id: \.element.id) {
                    index, prayer in
                    PrayerListItem(
                        prayer: prayer,
                        currentPrayerIndex: speaker.currentPrayerIndex,
                        index: index,
                        speaker: speaker
                    )
                }

            }
            .listStyle(.plain)
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            
            if prayerType == .none {
                
                Group {
                    HStack {
                        Button("Start Auto") {
                            prayerType = .auto
                        }.padding()
                        
                        Button("Start Manual") {
                            prayerType = .manual
                        }
                    }
                }
                
            } else if prayerType == .auto {
                
                AutoBottomBar(
                    speaker: speaker,
                    rosaryType: $prayerType,
                    prayerSequence: prayerSequence,
                    isSpeaking: $speaker.isSpeaking,
                    isPaused: $speaker.isPaused
                )
                
            } else {
                
                ManualBottomBar(
                    speaker: speaker,
                    rosaryType: $prayerType,
                    prayerSequence: prayerSequence
                )
                
            }
            
        }
        .onAppear {
            
//            save(
//                modelContext: modelContext,
//                prayerTitle: "Hello",
//                prayers: PrayerData.prayers
//            )

            loadPrayers(using: modelContext, prayer: prayer)
                        
            speaker.voice = settings.voice
            
            speaker.speakAloud = settings.speakAloud
            
        }

    }
    
    func save(
        modelContext: ModelContext,
        prayerTitle: String,
        prayers: [Prayer]
    ) {
        
        var items: [PrayerSwiftDataItem] = []
        
        do {
            
            let customPrayer = CustomPrayer(
                name: prayerTitle,
                orderIndex: 0,
                prayerSwiftDataItems: []
            )
            
            customPrayer.id = prayer.id
            
            for currentPrayer in prayers {
                let _prayer = PrayerSwiftDataItem(
                    name: currentPrayer.name,
                    data: currentPrayer.data,
                    orderIndex: 0,
                    customPrayer: customPrayer
                )
                
                items += [_prayer]
                
            }
            modelContext.insert(customPrayer)
            
            try modelContext.save()
            
        } catch {}

    }
    
    func loadPrayers(using context: ModelContext, prayer: Prayer) {
                
        do {
            
            let descriptor = FetchDescriptor<CustomPrayer>(
                predicate: #Predicate { $0.id == prayer.id },
                sortBy: [SortDescriptor(\.orderIndex)]
            )
            
            let allPrayers = try context.fetch(descriptor)
            
            guard let foundPrayer = allPrayers.first else { return }
            
            prayerSequence = foundPrayer.prayerSwiftDataItems
                .map { PrayerSwiftDataItem in
                Prayer(from: PrayerSwiftDataItem)
            }
            
        } catch {
            print("Error fetching prayers: \(error)")
        }
        
    }

        
}

struct PrayerListItem: View {
    
    var prayer: Prayer;
    @State var isOpen = false
    var currentPrayerIndex: Int
    var index: Int
    @ObservedObject var speaker: RosarySpeaker
    
    var isActice: Bool {
        return currentSpeaking || isOpen
    }
    
    var currentSpeaking: Bool {
        return (index == currentPrayerIndex && speaker.isSpeaking)
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "speaker")
                Text(prayer.name)
                if currentSpeaking {
                    Image(systemName: "speaker.wave.2.circle.fill")
                }
                Spacer()
                
                Image(systemName: isOpen ? "chevron.up" : "chevron.down")
            }
            .padding()
            .onTapGesture {
                isOpen.toggle()
            }

            Divider()

            if isActice {
                
                VStack {
                    CurrentTextDisplayViewV2(
                        currentText: prayer.data,
                        range: speaker.currentWordRange
                    )
                }
                .animation(.easeInOut)
                
            }
        }
    }
}

#Preview {
    
    SeriesPrayerView(prayer: Binding<Prayer>(
        get: {
            Prayer(
                id: UUID(uuidString: "463E8FC0-998B-4D85-9A35-2B70DA638BA7")!,
                name: "",
                type: .series,
                data: ""
            )
        },
        set: { _ in}
    )).modelContainer(
        for: [PrayerSwiftDataItem.self, CustomPrayer.self],
        inMemory: true
    ).environmentObject(GlobalSettings())
        
}

#Preview {
    NavigationStack {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            PrayersViewV2().tabItem { Text("Prayers") }.tag(1)
            AddCustomPrayerView().tabItem { Text("Add Custom Prayer") }.tag(2)
        }
    }.modelContainer(
        for: [PrayerSwiftDataItem.self, CustomPrayer.self],
        inMemory: true
    ).environmentObject(GlobalSettings())
}
