//
//  ChosenBookViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 17/07/2021.
//

import UIKit

class ChosenBookViewController: UIViewController {

    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var chaptersPicker: UIPickerView!
    
    @IBOutlet var tap: UITapGestureRecognizer!
    
    var bookTitle: String?
    
    @IBOutlet weak var bookSelect: UIButton!
    
    var currentRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        chaptersPicker.delegate = self
        chaptersPicker.dataSource = self
        
        bookSelect.layer.cornerRadius = 0.5 * bookSelect.bounds.size.width
        
        
        bookCover.image = UIImage(named: bookTitle!)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapper(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChosenBookViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return K.bookChapterNames[bookTitle!]!.count
    }
    
    
}

extension ChosenBookViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return K.bookChapterNames[bookTitle!]![row]
            }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentRow = pickerView.selectedRow(inComponent: 0)
    }
    
    
    @IBAction func bookSelectPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.readBook, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.readBook {
            let destinationVC = segue.destination as! BookViewController
            destinationVC.bookTitle = bookTitle
            destinationVC.chapterNumber = currentRow
        }
    }
}
