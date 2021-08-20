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
    
    // Variable to check if speech is currently playing
    static var isPlaying = false

    let speechSynthesizer = AVSpeechSynthesizer()

    
    //MARK: - Speech Methods
    
    func startSpeech(_ text: String) {
        // Function to start speech  playing
        
        // Set language
        if let language = NSLinguisticTagger.dominantLanguage(for: text) {
            
            // ipPlaying to true
            SpeechService.isPlaying = true
            
            // Pass text to be spoken to AVSpeechUtterence
            let utterence = AVSpeechUtterance(string: text)
            utterence.voice = AVSpeechSynthesisVoice(language: language)
            
            // Speek
            speechSynthesizer.speak(utterence)
        }
    }
    
    func stopSpeeching() {
        // Stop speech and set isPlayern to false
        speechSynthesizer.stopSpeaking(at: .immediate)
        SpeechService.isPlaying = false
    }
    
    //MARK: - Additional
    
    func changedChapter(_ text: String) {
        // Method to start speeking the new chapter is the chapter is changed while speeking
        
        if SpeechService.isPlaying {
            stopSpeeching()
            startSpeech(text)
        }
    }
    
    func renderStopButton() -> Bool {
        // Function to check if a view should show the stop speeking button in the nav bar
        
        if SpeechService.isPlaying {
            return true
        }
        return false
    }
}
