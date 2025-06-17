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
    
    var body: some View {
        
        RosaryHeader(
            prayer: prayer,
            rosaryType: rosaryType,
            pauseAction: {
                speaker.pause()
            },
            speaker: speaker
        )
        
        RosarySimpleDecadeView(currentBeadIndex: speaker.bead, onBeadTap: onBeadTap)

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
                
                CurrentTextDisplayView(
                    words: speaker.words,
                    highlightIndex: speaker.currentWordIndex
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
                            prayerSequence: prayerSequence
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
            speaker.setPrayerQueue(prayerSequence)
        }
        
    }
    
    init(prayer: Binding<Prayer>) {
        
        self._prayer = prayer
        self.prayerSequence = RosaryUtils().constructRosary()
        
    }
    
    func onBeadTap(index: Int) {
        
        print(index)
        if rosaryType == .auto || rosaryType == .none { return }

        speaker.currentPrayerIndex = index
        speaker.speakNextPrayer()
        
    }
    
}

#Preview {
    RosaryView(
        prayer: .constant(Prayer(name: "Rosary", type: .rosary, data: ""))
    )
}


struct AutoBottomBar: View {
    
    public var speaker: RosarySpeaker
    @Binding var rosaryType: RosaryType
    public var prayerSequence: [Prayer]
    
    var body: some View {
        
        Button(action: {
            autoPrayer()
        }) {
            Label("Start", systemImage: "speaker.wave.2.fill")
        }
        .padding()
        
        if speaker.isSpeaking {
            
            Button(action: {
                pausePrayer()
            }) {
                Label("Pause", systemImage: "pause.fill")
            }
            .padding()
            
            Button(action: {
                speaker.stopPrayer()
            }) {
                Label("Stop", systemImage: "stop.fill")
            }

        }
        
        if !speaker.isSpeaking {
            Button(action: {
                resumePrayer()
            }) {
                Label("Resume", systemImage: "reload.circle.fill")
            }
            .padding()
        }
                
        Button(action: {
            rosaryType = .none
        }) {
            Label("Cancel", systemImage: "cancel.circle.fill")
        }

    }
    
    func autoPrayer() {
        
        DispatchQueue.main.async {

            speaker.speakPrayers(prayerSequence)

        }
        
    }
    
    func pausePrayer() {
        speaker.pause()
        
    }
    
    func resumePrayer() {
        speaker.resume()
    }


}


struct ManualBottomBar: View {
    
    public var speaker: RosarySpeaker
    @Binding var rosaryType: RosaryType
    public var prayerSequence: [Prayer]

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
                speaker.stopPrayer();
                rosaryType = .none
            }) {
                Label("Cancel", systemImage: "cancel.circle.fill")
            }
            
        }
    }
    
    func nextPrayer() {

        speaker.speakNextPrayer()
        
    }
    
    func prevPrayer() {

        speaker.speakPreviousPrayer()

    }

}
