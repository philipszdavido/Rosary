//
//  RosaryView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import SwiftUI
import SwiftData

extension Text {
    public func white() -> Text {
        return self.foregroundStyle(.gray)
    }
}

struct RosaryView: View {
    
    @Binding var prayer: Prayer
    @StateObject private var speaker: RosarySpeaker = RosarySpeaker()
    @State var rosaryType = RosaryType.none
    
    var prayerSequence: [Prayer] = []
    @EnvironmentObject var settings: GlobalSettings
    
    var body: some View {
                
        RosaryHeader(
            prayer: prayer,
            rosaryType: rosaryType,
            speaker: speaker
        )
        
        ScrollView {
            
            if settings.showBeadCounting {

                RosarySimpleDecadeView(
                    currentBeadIndex: $speaker.bead,
                    prayerSequence: prayerSequence,
                    onBeadTap: onBeadTap
                )
                
            }
            
            VStack(alignment: .leading) {

                
                if prayerSequence.isEmpty {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("No prayers found.")
                        Spacer()
                    }
                }
                
                if speaker.currentPrayerIndex < prayerSequence.count {
                    
                    Text("Prayer")
                        .font(.headline)
                        .fontDesign(.default)
                        .textCase(.uppercase)
                        .foregroundStyle(.gray)
                        .bold()
                    
                    Text(prayerSequence[speaker.currentPrayerIndex].name)
                        .font(.headline)
                        .fontDesign(.default)
                        .bold()
                }
                
                if speaker.isSpeaking {
                    
                    CurrentTextDisplayViewV2(
                        currentText: speaker.prayerQueue.isEmpty ? "" : speaker.prayerQueue[speaker.currentPrayerIndex].data,
                        range: speaker.currentWordRange
                    )
                    
                } else {
                    
                    if speaker.currentPrayerIndex < prayerSequence.count {
                        
                        Text(prayerSequence[speaker.currentPrayerIndex].data)
                            .font(
                                Font?.init(
                                    .system(
                                        size: 20,
                                        weight: .bold,
                                        design: .default
                                    )
                                )
                            )
                            .font(.body)
                            .fontWeight(.regular)
                        
                            .padding(.top, 3.0)
                            .foregroundColor(.gray)
                    }
                    
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .leading, .trailing, .bottom])
            .background(Color.gray.opacity(0.1))
            .padding([.top, .leading, .trailing, .bottom], 5)
            
        }
            
        
            Spacer()
            
        HStack {
            if !prayerSequence.isEmpty {
                
                if rosaryType == RosaryType.none {
                    
                    Group {
                        
                        Button(action: {
                            rosaryType = RosaryType.auto
                        }) {
                            Label("Start Auto", systemImage: "autostartstop")
                        }.padding()
                        
                        Button(action: {
                            rosaryType = RosaryType.manual
                        }) {
                            Label("Start Manual", systemImage: "book.and.wrench")
                        }
                        
                    }
                } else {
                    
                    Group {
                        
                        if rosaryType == RosaryType.auto {
                            
                            AutoBottomBar(
                                speaker: speaker,
                                rosaryType: $rosaryType,
                                prayerSequence: prayerSequence,
                                isSpeaking: $speaker.isSpeaking,
                                isPaused: $speaker.isPaused
                            )
                            
                        }
                        
                        if rosaryType == RosaryType.manual {
                            
                            ManualBottomBar(
                                speaker: speaker,
                                rosaryType: $rosaryType,
                                prayerSequence: prayerSequence
                            )
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    init(prayer: Binding<Prayer>) {
        self._prayer = prayer
        self.prayerSequence = RosaryUtils().constructRosary()
    }

    init(prayer: Binding<Prayer>, prayerSequence: [Prayer]) {
        self._prayer = prayer
        self.prayerSequence = prayerSequence
    }

    func onBeadTap(index: Int, beadIndex: Int) {
                
        if rosaryType == .auto || rosaryType == .none { return }
        
        if beadIndex < speaker.bead { return }
        
        if beadIndex > (speaker.bead + 1) { return }

        speaker.currentPrayerIndex = index
        speaker.bead = beadIndex;
        speaker.speakCurrent()
        
    }
        
}

struct RosaryView2: View {
    
    @Environment(\.modelContext) var modelContext
    @Binding var prayer: Prayer
    @State private var prayerSequence: [Prayer] = []

    var body: some View {
        
        RosaryView(
            prayer: $prayer,
            prayerSequence: loadPrayers(
                using: modelContext,
                prayer: prayer
                )
            )
    }
    
    func loadPrayers(using context: ModelContext, prayer: Prayer) -> [Prayer] {
                
        var prayers: [Prayer] = []
                
        do {
            
            let descriptor = FetchDescriptor<CustomPrayer>(
                predicate: #Predicate { $0.id == prayer.id },
                sortBy: [SortDescriptor(\.orderIndex)]
            )
            
            let allPrayers = try context.fetch(descriptor)
                        
            guard let foundPrayer = allPrayers.first else { return [] }
            
            prayers = foundPrayer.prayerSwiftDataItems
                .map { PrayerSwiftDataItem in
                return Prayer(from: PrayerSwiftDataItem)
            }
                        
        } catch {
            print("Error fetching prayers: \(error)")
        }
        
        return prayers
        
    }

}

#Preview {
    RosaryView(
        prayer: .constant(Prayer(name: "Rosary", type: .rosary, data: ""))
    ).environmentObject(GlobalSettings())
}

//struct RosaryView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        let container = try! ModelContainer(
//            for: Schema([
//                PrayerSwiftDataItem.self,
//                CustomPrayer.self
//            ]),
//            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
//        )
//        
//        let context = container.mainContext
//
//        // Setup sample prayers
//        let prayers = [
//            Prayer(name: "Hail Mary", type: .bead, data: "Hail Mary..."),
//            Prayer(name: "Our Father", type: .bead, data: "Our Father...")
//        ]
//        
//        let customPrayer = CustomPrayer(
//            name: "UIO",
//            orderIndex: 0,
//            prayerSwiftDataItems: []
//        )
//        customPrayer.id = UUID(uuidString: "463E8FC0-998B-4D85-9A35-2B70DA638BA7")!
//        customPrayer.isRosary = true
//
//        for (i, p) in prayers.enumerated() {
//            let item = PrayerSwiftDataItem(
//                name: p.name,
//                data: p.data,
//                orderIndex: i,
//                type: .bead,
//                customPrayer: customPrayer
//            )
//            customPrayer.prayerSwiftDataItems.append(item)
//        }
//        
//        context.insert(customPrayer)
//        try! context.save()
//
//        return RosaryView2(
//            prayer: .constant(
//                Prayer(
//                    id: customPrayer.id,
//                    name: customPrayer.name,
//                    type: .rosary,
//                    data: ""
//                )
//            )
//        )
//        .modelContainer(container)
//        .environmentObject(GlobalSettings())
//    }
//}

struct RosaryPreviewLoaderView: View {

    @Environment(\.modelContext) private var modelContext
    @State private var isSetupDone = false

    var body: some View {
        RosaryView2(
            prayer: .constant(
                Prayer(
                    id: UUID(uuidString: "463E8FC0-998B-4D85-9A35-2B70DA638BA7")!,
                    name: "Rosary",
                    type: .rosary,
                    data: ""
                )
            )
        )
        .onAppear {
            if !isSetupDone {
                setupSampleData()
                isSetupDone = true
            }
        }
    }

    func setupSampleData() {
        let prayers = [
            Prayer(name: "Hail Mary", type: .bead, data: "Hail Mary..."),
            Prayer(name: "Our Father", type: .bead, data: "Our Father...")
        ]

        let customPrayer = CustomPrayer(
            name: "UIO",
            orderIndex: 0,
            prayerSwiftDataItems: []
        )
        customPrayer.id = UUID(uuidString: "463E8FC0-998B-4D85-9A35-2B70DA638BA7")!
        customPrayer.isRosary = true

        for (i, p) in prayers.enumerated() {
            let item = PrayerSwiftDataItem(
                name: p.name,
                data: p.data,
                orderIndex: i,
                type: p.type,
                customPrayer: customPrayer
            )
            customPrayer.prayerSwiftDataItems.append(item)
        }

        modelContext.insert(customPrayer)

        do {
            try modelContext.save()
        } catch {
            print("Failed to save preview data: \(error)")
        }
    }
}

#Preview {
    RosaryPreviewLoaderView()
        .modelContainer(for: [CustomPrayer.self, PrayerSwiftDataItem.self], inMemory: true)
        .environmentObject(GlobalSettings())
}

