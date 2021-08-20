//
//  ChosenBookViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 17/07/2021.
//

import UIKit

class ChosenBookViewController: UIViewController {

    // IBOutlets for the book image and chapter picker
    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var chaptersPicker: UIPickerView!
    
    // Tap recogniser
    @IBOutlet var tap: UITapGestureRecognizer!
    
    
    // IBOutlet collection of buttons to round
    @IBOutlet var buttons: [UIButton]!
    
    // Book title string
    var bookTitle: String?
    
    // current row in picker
    var currentRow = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set delegates
        chaptersPicker.delegate = self
        chaptersPicker.dataSource = self
        
        // Round corners
        roundCorners(buttons)
        
        // Display book cover
        bookCover.image = UIImage(named: bookTitle!)
    }
    
    
//MARK: - Dismiss VC
    
    // Methods to dismiss the VC
    
    @IBAction func tapper(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}


//MARK: - Picker View Data Source

extension ChosenBookViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return K.bookChapterNames[bookTitle!]!.count
    }
}


//MARK: - Picker View Delegate

extension ChosenBookViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Chapter name to display
        
        return K.bookChapterNames[bookTitle!]![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Pass selected row to variable
        
        currentRow = pickerView.selectedRow(inComponent: 0)
    }
}


//MARK: - Segue

extension ChosenBookViewController {
    
    @IBAction func bookSelectPressed(_ sender: UIButton) {
        // Perform segue
        
        performSegue(withIdentifier: K.readBook, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass book and chapter details to next VC
        
        if segue.identifier == K.readBook {
            let destinationVC = segue.destination as! BookViewController
            destinationVC.bookTitle = bookTitle
            destinationVC.chapterNumber = currentRow
        }
    }
}
