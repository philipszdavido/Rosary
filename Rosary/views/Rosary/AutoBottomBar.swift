//
//  AutoBottomBar.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 28/06/2025.
//

import SwiftUI

struct AutoBottomBar: View {
    
    public var speaker: RosarySpeaker
    @Binding var rosaryType: RosaryType
    public var prayerSequence: [Prayer]
    @Binding var isSpeaking: Bool
    @Binding var isPaused: Bool
    
    var body: some View {
        HStack {
            if !isSpeaking && !isPaused {
                
                Button(action: {
                    autoPrayer()
                }) {
                    Label("Start", systemImage: "speaker.wave.2.fill")
                }
                .padding()
            }
            
            if isPaused {
                
                Button(action: {
                    resumePrayer()
                }) {
                    Label("Resume", systemImage: "reload.circle.fill")
                }
                .padding()
                
            }
            
            
            if isSpeaking {
                
                Button(action: {
                    pausePrayer()
                }) {
                    Label("Pause", systemImage: "pause.fill")
                }
                .padding()
                
            }
            
            Button(action: {
                cancel()
            }) {
                Label("Cancel", systemImage: "cancel.circle.fill")
            }.disabled(!isSpeaking)
        }

    }
    
    func autoPrayer() {
        
        DispatchQueue.main.async {

            speaker.speak(prayers: prayerSequence, auto: true)

        }
        
    }
    
    func pausePrayer() {
        speaker.pause()
        
    }
    
    func resumePrayer() {
        speaker.resume()
        
    }
    
    func cancel() {
        rosaryType = .none
        speaker.bead = 0
        speaker.currentPrayerIndex = 0
        speaker.isAuto = false
        speaker.stop()
    }
    
    func stop() {
        speaker.bead = 0
        speaker.currentPrayerIndex = 0
        speaker.isAuto = false
        speaker.stop()
    }

}

#Preview {
    AutoBottomBar(
        speaker: RosarySpeaker(),
        rosaryType: .constant(RosaryType.auto),
        prayerSequence: [Prayer.init(name: "", type: PrayerEnum.bead, data: "")],
        isSpeaking: .constant(true),
        isPaused: .constant(false)
    )
}
