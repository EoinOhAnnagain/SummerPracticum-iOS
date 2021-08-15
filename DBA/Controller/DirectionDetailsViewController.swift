//
//  DirectionDetailsViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 15/08/2021.
//

import UIKit

class DirectionDetailsViewController: UIViewController {

    var directions: String?
    @IBOutlet weak var directionsTextView: UITextView!
    
    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet weak var timeDetailsLabel: UILabel!
    @IBOutlet weak var fareDetailsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fareDetailsLabel.text = "\ngrgrwe\n\nfwuighuirwh\n\n\nfesuifhbewiuhg\n"
        timeDetailsLabel.text = "\ngrgrwe\n\nfwuighuirwh\n\n\nfesuifhbewiuhg\n"
        
        roundCorners(timeDetailsLabel)
        
        
        roundCorners(directionsTextView)
        directionsTextView.text = String(directions!.dropLast())
        // Do any additional setup after loading the view.
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
