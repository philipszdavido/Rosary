//
//  ManualBottomBar.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 28/06/2025.
//

import SwiftUI

struct ManualBottomBar: View {
    
    public var speaker: RosarySpeaker
    @Binding var rosaryType: RosaryType
    public var prayerSequence: [Prayer]
    
    @State private var next = true
    
    func isDidFinished() {
        if next {
            speaker.currentPrayerIndex += 1
        }
    }

    var body: some View {
        HStack {
            
            Button(action: {
                prevPrayer()
            }) {
                Label("Say Previous", systemImage: "arrowshape.backward.circle.fill")
            }
            .padding()
            
            Button(action: {
                nextPrayer()
            }) {
                Label("Say Prayer", systemImage: "arrowshape.forward.circle.fill")
            }
            
            Button(action: {
                cancel()
            }) {
                Label("Cancel", systemImage: "cancel.circle.fill")
            }
            
        }
    }
    
    func nextPrayer() {
        
        next = true
        
        if speaker.currentPrayerIndex == 0 {
            speaker.isDidFinished = isDidFinished
            speaker.speak(prayers: prayerSequence, auto: false)
        } else {
            speaker.speakNext()
        }
        
    }
    
    func prevPrayer() {

        
        if speaker.currentPrayerIndex > 0 {
            
            next = false

            speaker.speakPrevious()
        }

    }

    func cancel() {
        speaker.stop()
        rosaryType = .none
        speaker.bead = 0
        speaker.currentPrayerIndex = 0

    }

}

#Preview {
    ManualBottomBar(
        speaker: RosarySpeaker(),
        rosaryType: .constant(RosaryType.auto),
        prayerSequence: [PrayerData.gloryBePrayer()]
    )
}
