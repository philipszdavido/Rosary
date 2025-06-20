//
//  speech.swift
//  Rosary
//
//  Created by Chidume Nnamdi on 24/04/2025.
//

import Foundation
import AVFoundation
import UIKit

class PrayerSpeaker: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    
    @Published var currentPrayerIndex = 0
    {
        didSet {
            setBeadOptions(prayerIndex: currentPrayerIndex)
        }
    }
    public var previousCurrentPrayerIndex = 0
    
    @Published var isSpeaking = false
    @Published var isPaused = false
    @Published var currentWordRange: NSRange?
    @Published var spokenWord: String = ""
    var voice = "com.apple.ttsbundle.Samantha-compact"
    var speakAloud = true
    
    var prayerQueue: [Prayer] = []
    var isAuto = false
    
    var isDidFinished: () -> Void = {}
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(prayers: [Prayer], auto: Bool) {
        self.prayerQueue = prayers
        self.currentPrayerIndex = 0
        self.isAuto = auto
        speakCurrent()
    }
    
    func speakCurrent() {
        guard currentPrayerIndex < prayerQueue.count else { return }
        isSpeaking = true
        isPaused = false
        currentWordRange = nil
        spokenWord = ""
        
        let text = prayerQueue[currentPrayerIndex].data
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(identifier: voice)
        utterance.rate = 0.45  // Adjust for better word highlighting timing
        
        if !speakAloud {
            utterance.volume = 0  // This mutes the audio output
        }
        
        synthesizer.speak(utterance)

    }
    
    func speakNext() {
        guard !isSpeaking else { return }
        if currentPrayerIndex < prayerQueue.count {
            speakCurrent()
        }
    }
    
    func speakPrevious() {
        guard !isSpeaking else { return }
        currentPrayerIndex -= 1
        if currentPrayerIndex < prayerQueue.count {
            speakCurrent()
        }
    }
    
    func pause() {
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .word)
            isSpeaking = false
            isPaused = true
        }
    }
    
    func resume() {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
            isSpeaking = true
            isPaused = false
        }
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        isPaused = false
        currentWordRange = nil
        spokenWord = ""
    }
    
    func reset() {
        stop()
        currentPrayerIndex = 0
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        isPaused = false
        currentWordRange = nil
        spokenWord = ""
        
        if isAuto {
            currentPrayerIndex += 1
            if currentPrayerIndex < prayerQueue.count {
                speakCurrent()
            }
        }
        
        isDidFinished()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        // Track the range of the currently spoken word
        currentWordRange = characterRange
        
        let nsString = utterance.speechString as NSString
        let word = nsString.substring(with: characterRange)
        
        let attributedString = NSMutableAttributedString(
            string: nsString as String
        )
        attributedString
            .setAttributes(
                [NSAttributedString.Key.foregroundColor: UIColor.orange],
                range: currentWordRange!
            )
        
        DispatchQueue.main.async {
            self.spokenWord = word
        }
    }
    
    func setBeadOptions(prayerIndex: Int) {}
    
    private var workItem: DispatchWorkItem?
    
    func speakMute(_ text: String, wordDelay: TimeInterval = 0.4) {
        
        isSpeaking = true
        currentWordRange = nil
        workItem?.cancel()
        
        let words = text.components(separatedBy: .whitespaces)
        var position = 0
        
        func nextWord(index: Int) {
            guard index < words.count else {
                DispatchQueue.main.async {
                    self.isSpeaking = false
                    self.currentWordRange = nil
                }
                return
            }
            
            let word = words[index]
            
            // Find the range of the word starting from `position`
            if let range = text.range(of: word, options: [], range: text.index(text.startIndex, offsetBy: position)..<text.endIndex) {
                let nsRange = NSRange(range, in: text)
                DispatchQueue.main.async {
                    self.currentWordRange = nsRange
                }
                position = text.distance(from: text.startIndex, to: range.upperBound)
            }
            
            workItem = DispatchWorkItem {
                nextWord(index: index + 1)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + wordDelay, execute: workItem!)
        }
        
        nextWord(index: 0)
    }
    
    func stopMute() {
        workItem?.cancel()
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.currentWordRange = nil
        }
    }
    
}

class RosarySpeaker: PrayerSpeaker {
    
    @Published var bead = -1;
    
    override init() {
        super.init()
    }
    
    override func setBeadOptions(prayerIndex: Int) {
        
        let currentPrayer = prayerQueue[prayerIndex]
        
        if currentPrayer.type == .bead {
            
            if prayerIndex <= 0 {
                bead = -1
                return
            }
            
            if super.previousCurrentPrayerIndex > prayerIndex {
                bead -= 1
            } else {
                bead += 1
            }
            
        }
        
        super.previousCurrentPrayerIndex = prayerIndex
        
    }

}
