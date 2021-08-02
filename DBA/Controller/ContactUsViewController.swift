//
//  ContactUsViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 29/07/2021.
//

import UIKit
import IQKeyboardManagerSwift
import MessageUI

class ContactUsViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate {

    var userEmail: String?
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var firstPicker: UIPickerView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var issueTextView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if SpeechService.shared.renderStopButton() {
            bookStopButton.image = UIImage(systemName: "play.slash")
        } else {
            bookStopButton.image = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        roundButton(sendButton)
        roundButton(emailTextField)
        resultLabel.alpha = 0
        
        firstPicker.dataSource = self
        firstPicker.delegate = self
        
        emailTextField.delegate = self
        issueTextView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func bookStopButtonPressed(_ sender: UIBarButtonItem) {
        SpeechService.shared.stopSpeeching()
        navigationItem.setRightBarButton(nil, animated: true)
    }

    func setUp() {
        if userEmail != nil {
            emailTextField.alpha = 0
            firstLabel.alpha = 0
        }
    }
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        let picked = firstPicker.selectedRow(inComponent: 0)
        
        if picked == 0 {
            resultLabel.text = "Please select a subject"
            resultLabel.alpha = 1
            resultLabel.textColor = UIColor(named: "Interface")
        } else {
            
            
            var reason: String?
            var email: String?
            
            
            if picked == (K.contact.pickerOptions.count + 1) {
                reason = "Other"
            } else {
                reason = K.contact.pickerOptions[picked]
            }
            
            let toRecipients = ["eoin1711@gmail.com", "eoin.ohannagain@ucdconnect.ie", "eugene.egan1@ucdconnect.ie", "ming-han.ta@ucdconnect.ie", "junzheng.liu@ucdconnect.ie"]
            
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            
            if userEmail != nil {
                email = userEmail
            } else {
                email = emailTextField.text
            }
            
            if email == nil || email == "" {
                resultLabel.text = "Please include an email address."
                resultLabel.alpha = 1
                resultLabel.textColor = UIColor(named: "Interface")
            } else {
                
                let message =  issueTextView.text
                
                if message == nil || message == "" {
                    resultLabel.text = "Please include a message so we can help you."
                    resultLabel.alpha = 1
                    resultLabel.textColor = UIColor(named: "Interface")
                } else {
                    
                    mc.mailComposeDelegate = self
                    mc.setToRecipients(toRecipients)
                    mc.setSubject("\(reason!) - \(email!)")
                    
                    
                    
                    mc.setMessageBody("Email: \(email!) \n\nSubject: \(reason!) \n\nIssue: \(message!)", isHTML: false)
                    
                    self.present(mc, animated: true) {
                        
                    }
                }
            }
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            resultLabel.alpha = 0
        case MFMailComposeResult.failed.rawValue:
            resultLabel.text = "Message Sending Failed: \(error!.localizedDescription)"
            resultLabel.alpha = 1
            resultLabel.textColor = .red
        case MFMailComposeResult.saved.rawValue:
            resultLabel.alpha = 0
        case MFMailComposeResult.sent.rawValue:
            resultLabel.text = "Message Successfully Sent"
            resultLabel.alpha = 1
            resultLabel.textColor = .green
        default:
            resultLabel.alpha = 0
            break
        }
        
        self.dismiss(animated: true, completion: nil)
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

//MARK: - Rounding

extension ContactUsViewController {
    
    func roundButton(_ name: UIButton) {
        name.layer.cornerRadius = 0.4 * name.bounds.size.height
    }
    
    func roundButton(_ name: UITextField) {
        name.layer.cornerRadius = 0.4 * name.bounds.size.height
    }
}


// MARK: - Manage Return Key

extension ContactUsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
}

//MARK: - Picker View

extension ContactUsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return K.contact.pickerOptions.count + 2
    }
    
    
}

extension ContactUsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0 {
            return "Please Select an Option"
        }else if row == K.contact.pickerOptions.count + 1 {
            return "Other"
        } else {
            return K.contact.pickerOptions[row - 1]
        }
    }
    
}
