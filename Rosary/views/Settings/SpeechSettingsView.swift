//
//  SpeechSettingsView.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 17/06/2025.
//

import SwiftUI
import AVFoundation

struct SpeechSettingsView: View {
    
    @EnvironmentObject var settings: GlobalSettings
    @State private var speakPrayerAloud: Bool = true
    
    var body: some View {
        
        List {
            Section {
                VStack {
                    Toggle("Speak Prayer", isOn: Binding<Bool>(
                        get: { speakPrayerAloud },
                        set: { _ in speakPrayerAloud.toggle() }
                    ))
                    
                    NavigationLink(
                        destination:  ListOfVoices(settings: settings)
                    ) {
                        Text("Select Voice (\(settings.voice))")
                    }
                }
            }
        }
    }
}

struct ListOfVoices: View {
    
    public var settings: GlobalSettings
    let voices = AVSpeechSynthesisVoice.speechVoices()

    var body: some View {
        List {
            ForEach(voices, id: \.self) { voice in
                HStack {
                    
                    if settings.voice == voice.identifier {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                    }
                    
                    Text(voice.name)
                    Text("(\(voice.language))")
                    Spacer()
                    Text(voice.quality == .enhanced ? "Enhanced" : "Default")
                }.onTapGesture {
                    settings.voice = voice.identifier
                    print(">>> Set voice to '%s'\n", voice.identifier)
                }
            }
        }
    }
    
    func listAvailableVoices() {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        
        for voice in voices {
            print("""
            Name: \(voice.name)
            Language: \(voice.language)
            Identifier: \(voice.identifier)
            Quality: \(voice.quality == .enhanced ? "Enhanced" : "Default")
            ---
            """)
        }
    }
}

#Preview {
    NavigationView {
        SpeechSettingsView()
            .environmentObject(GlobalSettings())
    }
}
