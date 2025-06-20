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
                        word: prayer.data,
                        range: speaker.currentWordRange
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
                speaker.speak(prayers: [prayer], auto: false)
            }) {
                Label("Speak Prayer", systemImage: "speaker.wave.2.fill")
            }
            .padding()
            
            Button(action: {
                speaker.stop()
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

    let word: String
    let range: NSRange?
    
    @EnvironmentObject var settings: GlobalSettings
    
    func setAttribute(word: String, range: NSRange?) -> AttributedString {

        if let range = range {
            
            let mutableAttr = NSMutableAttributedString(string: word)
            
            mutableAttr
                .setAttributes(
                    [NSAttributedString.Key.foregroundColor : UIColor(settings.highlightColor)],
                    range: range
                )
            
            return AttributedString(mutableAttr)
        }
        
        return AttributedString(word)
    }
    
    var body: some View {

        Text(setAttribute(word: word, range: range))
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
