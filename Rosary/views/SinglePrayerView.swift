//
//  SinglePrayerView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import SwiftUI

struct SinglePrayerView: View {
    
    @StateObject private var speaker = PrayerSpeaker()
    @Binding var prayer: Prayer
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var settings: GlobalSettings
    
    var body: some View {
        
        HStack {
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
        
        VStack {
            
            ScrollView {
                
                if (speaker.isSpeaking) {
                    TextDisplayView(
                        words: speaker.words,
                        highlightIndex: speaker.currentWordIndex
                    )
                } else {
                    
                    Text(prayer.data)
                        .font(
                            Font?.init(
                                .system(
                                    size: 24,
                                    weight: .bold,
                                    design: .default
                                )
                            )
                        )
                        .font(.body)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        
                        .padding(.top, 20.0)

                }
                                                
            }
                
            Spacer()
        }
        .padding(.horizontal, 20.0)
        
        Spacer()
        
        HStack {
            Button(action: {
                speaker.speakPrayer(prayer.data)
            }) {
                Label("Speak Prayer", systemImage: "speaker.wave.2.fill")
            }
            .padding()
            
            Button(action: {
                speaker.stopPrayer()
            }) {
                Label("Stop Prayer", systemImage: "stop.fill")
            }
            .padding()

        }.onAppear{
            speaker.voice = settings.voice
        }
        
    }
}

#Preview {
    NavigationStack{
        SinglePrayerView(
            prayer:
                    .constant(
                        Prayer(
                            name: "Hail Mary",
                            type: .single,
                            data: PrayerData.hailMary
                        )
                    )
        ).environmentObject(GlobalSettings())
    }
}

struct TextDisplayView: View {
    let words: [String]
    let highlightIndex: Int
    let settings = GlobalSettings()
    
    var body: some View {
        // Combine Text views for each word
        words.enumerated().reduce(Text(""), { (result, pair) in
            let (index, word) = pair
            let styledWord: Text = index == highlightIndex
            ? Text(word + " ")
                .foregroundColor(settings.highlightColor)
                .bold()
                : Text(word + " ")
            return result + styledWord
        })
        .font(
            Font?.init(
                .system(
                    size: 24,
                    weight: .bold,
                    design: .default
                )
            )
        )
        .font(.body)
        .fontWeight(.regular)
        .multilineTextAlignment(.center)
        
        .padding(.top, 20.0)

    }
}

struct ItemsView: View {

    let items: [String]
    let highlightIndex: Int
    let settings = GlobalSettings()

    var body: some View {
        highlightWord
                .padding()
    }
    
    var highlightWord: Text {
        var result = Text("")

        for (index, item) in items.enumerated() {
            let styledItem: Text

            if index == highlightIndex {
                styledItem = Text(item)
                    .foregroundColor(settings.highlightColor)
            } else {
                styledItem = Text(item)
            }
            
            result = result + Text(" ") + styledItem
        }
        
        return result
        
    }
    
}
