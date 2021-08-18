//
//  BookViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 12/07/2021.
//

import UIKit

class BookViewController: UIViewController {
    
    @IBOutlet weak var bookText: UITextView!
    @IBOutlet weak var mediaButton: UIButton!
    
    
    var bookTitle: String?
    var chapterNumber: Int?
    var fileName: String?
    
    var playing = false
    
    var currentFontSize: CGFloat = 14
    
    @IBOutlet weak var fontView: UIView!
    
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFileName()
        readChapter()
        SpeechService.shared.changedChapter(bookText.text)
        
        roundCorners(buttons)
        
        //bookPicker.dataSource = self
        //bookPicker.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    func setFileName() {
        fileName = bookTitle!+String(chapterNumber!)
    }
    
    func readChapter() {
        let fileURLProject = Bundle.main.path(forResource: "Books/\(bookTitle!)/\(fileName!)", ofType: "txt")
        var readStringProject = ""
        do {
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed to read fom project")
            print(error)
        }
        //bookText.text =  String(readStringProject.filter { !"\n".contains($0) })
        bookText.text = readStringProject
        bookText.scrollRangeToVisible(NSRange(location: 0, length: 0))
        
    }
    
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func previousPressed(_ sender: UIButton) {
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
        bookText.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func mediaButtonPressed(_ sender: UIButton) {
        
        if SpeechService.isPlaying {
            //Audio is playing (to stop)
            //bookText.becomeFirstResponder()
            SpeechService.shared.stopSpeeching()
        } else {
            //Audio not playing (to start)
            //bookText.resignFirstResponder()
            SpeechService.shared.startSpeech(bookText.text)
        }
        
    }
    
    //MARK: - Font Controls
    
    @IBAction func fontButtonPressed(_ sender: UIButton) {
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
    
    @IBAction func increaseFontSize(_ sender: UIButton) {
        if currentFontSize < 24 {
            currentFontSize += 1
            bookText.font = .systemFont(ofSize: currentFontSize)
        }
    }
    
    @IBAction func decreaseFontSize(_ sender: UIButton) {
        if currentFontSize > 1 {
            currentFontSize -= 1
            bookText.font = .systemFont(ofSize: currentFontSize)
        }
        
    }
    
    @IBAction func defaultFontSize(_ sender: UIButton) {
        currentFontSize = 14
        bookText.font = .systemFont(ofSize: currentFontSize)
    }
    
    
}

