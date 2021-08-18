//
//  ConductViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 08/08/2021.
//

import UIKit

class ConductViewController: UIViewController {

    @IBOutlet var tap: UITapGestureRecognizer!
    
    @IBOutlet weak var conductText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        conductText.text = "This chat feature is for the express purpose of discussing the Dublin Bus routes and sharing current information reguarding such. Any user found to be using the chat feature for nefarious purposes will have their account banned without compensation and, depending on the nature of their abuse, reported to the relevent authorities.\n\nIf you see a user abusing the app please use the contact us page to inform us. If you do please include the chat room and details of the message (date/time found by tapping the message).\n\nMessages are anonymous between users but are linked to your login. No information stored by the app will be shared with 3rd parties.\n\nPlease note that messages sent from selected Dublin Bus employees and admin use a difference colour scheme."
    }
    
    @IBAction func tapper(_ sender: Any) {
        print("tap")
        dismiss(animated: true, completion: nil)
    }
}
