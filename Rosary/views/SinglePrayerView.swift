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
            Text("Simple Prayer")
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
            
        CardView {
            
            Text(prayer.name)
                .font(.headline)
            
            if (speaker.isSpeaking) {
                
                TextDisplayView(
                    word: prayer.data,
                    range: speaker.currentWordRange
                )
                .foregroundColor(.secondary)
                
                
            } else {
                
                Text(prayer.data)
                    .foregroundColor(.secondary)
                
            }
            
        }
            
        
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
            // speaker.voice = settings.voice
            // speaker.speakAloud = settings.speakAloud
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
                            data: PrayerData._hailMary
                        )
                    )
        )
    }.environmentObject(GlobalSettings())
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

    }
}

struct CardView<Content: View>: View {
    
    @EnvironmentObject private var settings: GlobalSettings
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            content.font(
                Font?.init(
                    .system(
                        size: 19,
                        weight: .regular,
                        design: .default
                    )
                )
            )
            .multilineTextAlignment(.leading)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.systemBackground))
                //.shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .stroke(
                    settings
                        .getColorWithKey(
                            SimplePrayerSettings.borderColor
                                .rawValue) ?? .mint,
                    lineWidth: 1
                )
        )
        .padding(.horizontal)
        
    }
}
