//
//  SpeechService.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 28/07/2021.
//

import Foundation
import AVKit

class SpeechService: NSObject {
    
    // Shared instance
    static let shared = SpeechService()
    
    static var isPlaying = false
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    //MARK: - Speech Methods
    
    func startSpeech(_ text: String) {
        
        if let language = NSLinguisticTagger.dominantLanguage(for: text) {
            
            SpeechService.isPlaying = true
            
            let utterence = AVSpeechUtterance(string: text)
            utterence.voice = AVSpeechSynthesisVoice(language: language)
            
            speechSynthesizer.speak(utterence)
        }
    }
    
    func stopSpeeching() {
        speechSynthesizer.stopSpeaking(at: .immediate)
        SpeechService.isPlaying = false
    }
    
    //MARK: - Additional
    
    func changedChapter(_ text: String) {
        
        if SpeechService.isPlaying {
            stopSpeeching()
            startSpeech(text)
        }
    }
    
    func renderStopButton() -> Bool {
        if SpeechService.isPlaying {
            return true
        }
        return false
    }
}
