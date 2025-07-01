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
    
    var formatVoiceDisplay: String {
        return String(settings.voice.split(separator: ".").last ?? "")
    }
    
    var body: some View {
        
        List {
            Section {
                VStack {
                    Toggle("Speak Prayer", isOn: Binding<Bool>(
                        get: { settings.speakAloud },
                        set: { _ in settings.speakAloud.toggle() }
                    ))
                    
                    NavigationLink(
                        destination:  ListOfVoices()
                    ) {
                        Text("Select Voice (\(formatVoiceDisplay))")
                    }
                }
            }
        }
    }
}

struct ListOfVoices: View {
    
    @EnvironmentObject var settings: GlobalSettings
    let voices = AVSpeechSynthesisVoice.speechVoices()
    var speaker = PrayerSpeaker()

    var body: some View {
        List {
            ForEach(voices, id: \.self) { voice in
                HStack {
                    HStack {
                        
                        Text(voice.name)
                        Text("(\(voice.language))")
                        
                        Spacer()
                        if settings.voice == voice.identifier {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                        Text(voice.quality == .enhanced ? "Enhanced" : "Default")
                        
                    }
                    .onTapGesture {
                        settings.voice = voice.identifier
                        // print(">>> Set voice to '%s'\n", voice.identifier)
                    }
                    .padding(10)
                    
                    Button {
                        
                        speaker.speakAloud = true;
                        speaker.voice = voice.identifier
                        speaker.speak(
                            prayers: [
                                Prayer(
                                    name: "Test",
                                    type: PrayerEnum.single,
                                    data: "Hello, this is " + voice.name
                                )
                            ],
                            auto: false
                        )
                        
                    } label: {
                        Image(systemName: "speaker.wave.3.fill")
                    }

                }
            }
        }.navigationTitle("Voices")
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
        
        ListOfVoices()
    }
        .environmentObject(GlobalSettings())
}

#Preview {
    NavigationView {
        SpeechSettingsView()
            
    }.environmentObject(GlobalSettings())
}
