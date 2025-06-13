//
//  speech.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import Foundation
import AVFoundation

class PrayerSpeaker: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    
    @Published var words: [String] = []
    @Published var currentWordIndex: Int = -1 // -1 means no word is highlighted
    @Published var isSpeaking: Bool = false
    
    private var originalText: String = ""
    private var lastMatchedWordIndex: Int = -1 // NEW
    
    @Published public var prayerQueue: [Prayer] = [] // <- New: queue of prayers
    @Published var currentPrayerIndex: Int = 0 // <- New: track which one we're speaking
    @Published var currentPrayer: Prayer? = nil
    var speakNextPrayerOnCompletion: Bool = true
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func setPrayerQueue(_ prayers: [Prayer]) {
        self.prayerQueue = prayers
    }
        
    func speakPrayer(_ text: String) {

        speakNextPrayerOnCompletion = false;

        stopPrayer()
        
        prayerQueue = [PrayerData.constructPrayer(text, name: text)];
        currentPrayerIndex = 0
        currentPrayer = prayerQueue[currentPrayerIndex]

        speakCurrentPrayer()

    }
    
    func speakNextPrayer() {
        stopPrayer()
        speakNextPrayerOnCompletion = false;
        speakCurrentPrayer()
    }
    
    func speakPreviousPrayer() {
        stopPrayer()
        speakNextPrayerOnCompletion = false;
        speakCurrentPrayer()
        currentPrayerIndex -= 1
    }
    
    func speakPrayers(_ prayers: [Prayer]) {

        speakNextPrayerOnCompletion = true;

        stopPrayer()
        
        prayerQueue = prayers
        currentPrayerIndex = 0
        currentPrayer = prayerQueue[currentPrayerIndex]

        speakCurrentPrayer()
        
    }

    private func speakCurrentPrayer() {
        
        guard currentPrayerIndex < prayerQueue.count else {
            isSpeaking = false
            currentWordIndex = -1
            return
        }

        self.setBeadOptions(wordIndex: self.currentWordIndex, prayerIndex: self.currentPrayerIndex);

        let text = prayerQueue[currentPrayerIndex].data
        originalText = text
        words = text.components(separatedBy: " ")
        currentWordIndex = -1

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.45
        
        isSpeaking = true
        synthesizer.speak(utterance);
        
    }
    
    func stopPrayer() {

        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

    }

    // Called at each word boundary
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let textNSString = utterance.speechString as NSString
        let spokenSubstring = textNSString.substring(with: characterRange)
        
        // Search only AFTER the last matched index
        //let searchRange = (lastMatchedWordIndex + 1)..<words.count
        DispatchQueue.main.async {
            self.lastMatchedWordIndex += 1 // update last matched
            self.currentWordIndex += 1
            print(
                "speechSynthesizer",
                self.currentWordIndex,
                self.lastMatchedWordIndex,
                spokenSubstring
            )
        }

//        if let index = words[searchRange].firstIndex(where: {
//            $0.trimmingCharacters(in: .punctuationCharacters) == spokenSubstring.trimmingCharacters(in: .punctuationCharacters)
//        }) {
//            let actualIndex = index + searchRange.lowerBound // Correct the offset
//            DispatchQueue.main.async {
//                self.currentWordIndex = actualIndex
//            }
//        }
    }

    // Called when finished
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isSpeaking = false
            self.currentWordIndex = -1;
            self.lastMatchedWordIndex = -1
                                    
            if (self.currentPrayerIndex + 1 < self.prayerQueue.count) {
                self.currentPrayerIndex += 1
                self.currentPrayer = self.prayerQueue[self.currentPrayerIndex]

                if self.speakNextPrayerOnCompletion {
                    self.speakCurrentPrayer() // <- New: automatically move to next prayer
                }

            }
            
        }
    }
    
    func setBeadOptions(wordIndex: Int, prayerIndex: Int) {
        
    }
        
}

class RosarySpeaker: PrayerSpeaker {
    
    @Published var bead = -1;
    
    override init() {
        super.init()
    }
    
    func start(rosary: [Prayer]) {
        super.speakPrayers(rosary)
    }
    
    override func setBeadOptions(wordIndex: Int, prayerIndex: Int) {
        
        //print(currentWordIndex, currentPrayerIndex)
        
        let currentPrayer: String = prayerQueue[prayerIndex].name
        
        if currentPrayer == "Our Father" {
            bead += 1
        }
        
        if currentPrayer == "Hail Mary" {
            bead += 1
        }
        
    }
    
}
