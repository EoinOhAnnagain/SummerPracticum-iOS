//
//  MapLegalViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 05/08/2021.
//

import UIKit
import GoogleMaps

class MapLegalViewController: UIViewController {

    @IBOutlet weak var legalText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        legalText.text = GMSServices.openSourceLicenseInfo()
        
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
