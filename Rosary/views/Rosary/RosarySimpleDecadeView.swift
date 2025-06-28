//
//  RosarySimpleDecadeView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 16/06/2025.
//

import SwiftUI

struct RosarySimpleDecadeView: View {
    
    @Binding public var currentBeadIndex: Int
    public var prayerSequence: [Prayer]
    public var onBeadTap: (_: Int, _: Int) -> Void;
    
    let columns = [
        GridItem(.adaptive(minimum: 20), spacing: 20)
    ]
    
    func isOurFather(prayer: Prayer) -> Bool {
        return prayer.name == "Our Father"
    }
    
    func isOurFather(index: Int) -> Bool {
        if index == 0 {
            return true // First Our Father bead
        }
        
        // After first 5 intro beads, every 11th bead is an Our Father bead
        let startOfDecades = 4
        return (index - startOfDecades) % 11 == 0 && index >= startOfDecades
    }
    
    func getBeadIndex(id: Int, prayer: Prayer) -> Int {
        
        let result = prayerSequence[0...id].filter { prayer in
            return prayer.type == PrayerEnum.bead
        }
        let index = result.firstIndex { currentPrayer in
            return currentPrayer.id == prayer.id
        }

        guard let prIndex = index else { return -1 }

        return prIndex
    }
        
    var body: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(0..<prayerSequence.count, id: \.self) { index in
                let prayer = prayerSequence[index]
                
                if prayer.type == .bead {

                    if isOurFather(prayer: prayer) {

                        let beadIndex = getBeadIndex(id: index, prayer: prayer)

                        OurFatherBeadView(
                            isCompleted: beadIndex < currentBeadIndex,
                            isActive: beadIndex == currentBeadIndex,
                            onTap: {
                                //print(
                                //    beadIndex,
                                 //   getBeadIndex(id: index, prayer: prayer)
                                //)
                                onBeadTap(index, beadIndex)
                            }
                        ).disabled(currentBeadIndex > beadIndex)
                        
                    } else {

                        let beadIndex = getBeadIndex(id: index, prayer: prayer)

                        BeadView(
                            isCompleted: beadIndex < currentBeadIndex,
                            isActive: beadIndex == currentBeadIndex,
                            onTap: {
                                onBeadTap(index, beadIndex)
                            }
                        ).disabled(currentBeadIndex > beadIndex)
                        
                    }
                }
            }
        }
        .padding(.horizontal)
        
    }
}


struct RosarySimpleDecadeView_Preview: View {
    
    @State private var index = 0
    
    func onBeadTap(index: Int, beadIndex: Int) {
        print(index)
    }
    
    var body: some View {
        RosarySimpleDecadeView(
            currentBeadIndex: Binding<Int>(
                get: { 2 },
                set: { if ($0 != 0) { $0 }}
            ),
            prayerSequence: RosaryUtils().constructRosary(),
            onBeadTap: onBeadTap
        )
    }
}

#Preview {
    RosarySimpleDecadeView_Preview()
        .environmentObject(GlobalSettings())
}


