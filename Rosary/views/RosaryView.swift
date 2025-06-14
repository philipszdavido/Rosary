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
    let numBeads: Int = 59;
    @StateObject private var speaker: RosarySpeaker = RosarySpeaker()
    @State var rosaryType = RosaryType.none
    private let decade = 5
    @Environment(\.dismiss) private var dismiss
    
    var prayerSequence: [Prayer] = []

    var body: some View {
        
        HStack(alignment: .center) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
            }.padding(.leading)
            Spacer()
            Text(prayer.name)
                .font(
                    Font?.init(
                        .system(
                            size: 24,
                            weight: .bold,
                            design: .default
                        )
                    )
                )
            Spacer()
        }
        Divider()

        RoundedRectangle(cornerRadius: 2, style: .circular)
            .fill(Color.gray.opacity(0.1))
            .frame(height: 100)
            .foregroundColor(.gray)
            .padding(.horizontal, 5)
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        Text(RosaryMystery.today().rawValue).white()
                        Text("Total Beads: \(numBeads)").white()
                        Text("Current Bead: \(speaker.bead)").white()
                    }.padding(.horizontal)
                    Spacer()
                }.padding(.horizontal)
            }
        
        RosaryDecadeView(decadeNumber: 1, currentBead: speaker.bead)
        RosaryDecadeView(decadeNumber: 2, currentBead: speaker.bead)
        RosaryDecadeView(decadeNumber: 3, currentBead: speaker.bead)
        RosaryDecadeView(decadeNumber: 4, currentBead: speaker.bead)
        RosaryDecadeView(decadeNumber: 5, currentBead: speaker.bead)

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
                        
                        Button(action: {
                            autoPrayer()
                        }) {
                            Label("Start", systemImage: "speaker.wave.2.fill")
                        }
                        .padding()
                        
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
                    
                    if rosaryType == RosaryType.manual {
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
                            
                        }
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
    
    func autoPrayer() {
        
        DispatchQueue.main.async {

            speaker.speakPrayers(prayerSequence)

        }
        
    }
    
    func pausePrayer() {
        
        
    }
    
    func nextPrayer() {

        speaker.speakNextPrayer()
        
    }
    
    func prevPrayer() {

        speaker.speakPreviousPrayer()

    }
    
}

#Preview {
    RosaryView(
        prayer: .constant(Prayer(name: "Rosary", type: .rosary, data: ""))
    )
}
