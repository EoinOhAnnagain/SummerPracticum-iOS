//
//  BookViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 12/07/2021.
//

import UIKit

class BookViewController: UIViewController {
    
    // IBOutlet for book text
    @IBOutlet weak var bookText: UITextView!
    
    // IBOutlets for controls
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var fontView: UIView!
    
    // IBOutlet collection for buttons to be rounded
    @IBOutlet var buttons: [UIButton]!
    
    // Book and chapter variables
    var bookTitle: String?
    var chapterNumber: Int?
    var fileName: String?
    
    // Is audio playing bool
    var playing = false
    
    // Font size variable
    var currentFontSize: CGFloat = 14
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Methods to set and display the relevent file
        setFileName()
        readChapter()
        
        // Pass the current chapter to speech services
        SpeechService.shared.changedChapter(bookText.text)
        
        // Round courners
        roundCorners(buttons)
    }
    
    
//MARK: - Display Current Chapter

    func setFileName() {
        // Use passed variables to generate the name of the file to retrieve
        fileName = bookTitle!+String(chapterNumber!)
    }
    
    func readChapter() {
        // Method to retrieve and display the .txt file using the generated file name
        
        // Path to file
        let fileURLProject = Bundle.main.path(forResource: "Books/\(bookTitle!)/\(fileName!)", ofType: "txt")
        
        // String to display when finished
        var readStringProject = ""
        
        do {
            // If there is no issue add the files text to the string
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
            
        } catch let error as NSError {
            print("Failed to read fom project")
            print(error)
        }
        
        // Display the text and scroll to the top of the chapter
        bookText.text = readStringProject
        bookText.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
    
    
//MARK: - General Buttons
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        // Dismiss VC
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func mediaButtonPressed(_ sender: UIButton) {
        // Stop and start audio if
        
        if SpeechService.isPlaying {
            SpeechService.shared.stopSpeeching()
        } else {
            SpeechService.shared.startSpeech(bookText.text)
        }
    }
    
    @IBAction func fontButtonPressed(_ sender: UIButton) {
        // Switch between font controls and chapter controls
        
        if fontView.alpha == 0 {
            UIView.animate(withDuration: 0.25) {
                self.fontView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.fontView.alpha = 0
            }
        }
    }
    
    
//MARK: - Chapter Buttons
    
    @IBAction func previousPressed(_ sender: UIButton) {
        // Method to display previosu chapter if there is one
        
        if chapterNumber! > 0 {
            chapterNumber! -= 1
            setFileName()
            readChapter()
            SpeechService.shared.changedChapter(bookText.text)
        } else {
            print("nope")
        }
    }
    
    @IBAction func forwardPressed(_ sender: UIButton) {
        // Method to display next chapter if there is one. Closes book otherwise.
        
        if chapterNumber!+1 < K.bookChapterNames[bookTitle!]!.count {
            chapterNumber! += 1
            setFileName()
            readChapter()
            SpeechService.shared.changedChapter(bookText.text)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func toTopPressed(_ sender: UIButton) {
        // Scroll to the top of the chapter
        
        bookText.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
    
    

    
    //MARK: - Font Buttons
    
    
    @IBAction func increaseFontSize(_ sender: UIButton) {
        // Increase font size up to 24
        
        if currentFontSize < 24 {
            currentFontSize += 1
            bookText.font = .systemFont(ofSize: currentFontSize)
        }
    }
    
    @IBAction func decreaseFontSize(_ sender: UIButton) {
        // Decrease font size as far as 1
        
        if currentFontSize > 1 {
            currentFontSize -= 1
            bookText.font = .systemFont(ofSize: currentFontSize)
        }
    }
    
    @IBAction func defaultFontSize(_ sender: UIButton) {
        // Return to default font size
        
        currentFontSize = 14
        bookText.font = .systemFont(ofSize: currentFontSize)
    }
}

