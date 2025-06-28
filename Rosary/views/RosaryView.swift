//
//  RosaryView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import SwiftUI

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
                
                if speaker.isSpeaking {
                    
                    CurrentTextDisplayViewV2(
                        currentText: speaker.prayerQueue.isEmpty ? "" : speaker.prayerQueue[speaker.currentPrayerIndex].data,
                        range: speaker.currentWordRange
                    )
                    
                } else {
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .leading, .trailing, .bottom])
            .background(Color.gray.opacity(0.1))
            .padding([.top, .leading, .trailing, .bottom], 5)
            
        }
            
        
            Spacer()
            
            HStack {
                
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
            .onAppear {
                speaker.voice = settings.voice
                speaker.speakAloud = settings.speakAloud
            }
        
        
    }
    
    init(prayer: Binding<Prayer>) {
        
        self._prayer = prayer
        self.prayerSequence = RosaryUtils().constructRosary()
        
    }
    
    func onBeadTap(index: Int, beadIndex: Int) {
        
        print(index, beadIndex, prayerSequence[index], speaker.prayerQueue[index])
        
        if rosaryType == .auto || rosaryType == .none { return }
        
        if beadIndex < speaker.bead { return }
        
        if beadIndex > (speaker.bead + 1) { return }

        speaker.currentPrayerIndex = index
        speaker.bead = beadIndex;
        speaker.speakCurrent()
        
    }
    
}

#Preview {
    RosaryView(
        prayer: .constant(Prayer(name: "Rosary", type: .rosary, data: ""))
    ).environmentObject(GlobalSettings())
}

