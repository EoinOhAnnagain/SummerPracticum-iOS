//
//  MapLegalViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 05/08/2021.
//

import UIKit
import GoogleMaps

class MapLegalViewController: UIViewController {

    // Text view for legal text
    @IBOutlet weak var legalText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Display legal text
        legalText.text = GMSServices.openSourceLicenseInfo()
    }
}
