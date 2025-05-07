//
//  RosaryView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import SwiftUI

struct RosaryView: View {
    
    @Binding var prayer: Prayer
    let numBeads: Int = 59;
    @State var currentBead: Int = 0;
    @StateObject private var speaker: RosarySpeaker = RosarySpeaker()
    @State var rosaryType = RosaryType.none
    
    var prayerSequence: [Prayer] = []

    var body: some View {
        Spacer()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {}) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        
        RosaryDecadeView(decadeNumber: 2, currentBead: speaker.bead)
        
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
        
        prayerSequence += [
            
            Prayer(name: "Sign Of The Cross", type: PrayerEnum.single, data: PrayerData.signOfTheCross),
            
            Prayer(
            name: "Our Father",
            type: PrayerEnum.single,
            data: PrayerData.ourFather
        )]
        
        for _ in 0..<numBeads {
            prayerSequence += [
                PrayerData.constructPrayer(PrayerData.hailMary, name: "Hail Mary"),
            ]
        }
        
        prayerSequence += [PrayerData.constructPrayer(PrayerData.gloryBe, name: "Glory Be")];
        
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

struct FullRosaryView: View {
    @State private var currentBead = 0
    let totalBeads = 59  // 1 start bead + 5 decades of 10 beads each (50) + 4 Our Father beads

    var body: some View {
        VStack(spacing: 20) {
            Text("Rosary - \(currentBead)/\(totalBeads) beads")
                .font(.title)
                .padding()

            VStack {
                RosaryDecadeView(decadeNumber: 1, currentBead: currentBead)
                RosaryDecadeView(decadeNumber: 2, currentBead: currentBead)
                RosaryDecadeView(decadeNumber: 3, currentBead: currentBead)
                RosaryDecadeView(decadeNumber: 4, currentBead: currentBead)
                RosaryDecadeView(decadeNumber: 5, currentBead: currentBead)
            }
            
            HStack {
                Button("Previous") {
                    if currentBead > 0 {
                        currentBead -= 1
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()

                Button("Next") {
                    if currentBead < totalBeads {
                        currentBead += 1
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

struct RosaryDecadeView: View {
    var decadeNumber: Int
    var currentBead: Int // Keeps track of the current bead
    var body: some View {
        HStack {
            ForEach(0..<10, id: \.self) { index in
                BeadView(isCompleted: index < currentBead, isActive: index == currentBead)
                    .onTapGesture {
                        // Action when a bead is tapped (optional, e.g., mark as prayed)
                    }
                if index == 4 { // Our Father bead in the middle
                    //Spacer()
                        //.frame(width: 20)
                }
            }
        }
    }
}

struct BeadView: View {
    var isCompleted: Bool
    var isActive: Bool

    var body: some View {
        Circle()
            .fill(isCompleted ? Color.green : (isActive ? Color.blue : Color.gray))
            .frame(width: 30, height: 40)
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2)
            )
            .shadow(radius: 5)
            .scaleEffect(isActive ? 1.2 : 1)  // Make the active bead slightly bigger
            .animation(.spring(), value: isActive)  // Smooth animation for active beads
    }
}

struct CurrentTextDisplayView: View {
    let words: [String]
    let highlightIndex: Int
    
    var body: some View {
        // Combine Text views for each word
        words.enumerated().reduce(Text(""), { (result, pair) in
            let (index, word) = pair
            let styledWord: Text = index == highlightIndex
            ? Text(word + " ")
                .foregroundColor(.orange)
                .bold()
                : Text(word + " ")
            return result + styledWord
        })
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
