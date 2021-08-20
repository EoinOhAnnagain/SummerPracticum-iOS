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

    
    // IBOutlet for navigation bar audio book button
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    // IBOutlets for the labels
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    // IBOutlet for the picker view
    @IBOutlet weak var firstPicker: UIPickerView!
    
    // IBOutlet for the text view
    @IBOutlet weak var issueTextView: UITextView!
    
    // IBOutlet for the send button
    @IBOutlet weak var sendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Round corners
        roundCorners(sendButton)
        roundCorners(issueTextView)
        roundCorners(sendButton)
        roundCorners(issueTextView)
        
        // Hide the result label
        resultLabel.alpha = 0
        
        // Set delegates
        firstPicker.dataSource = self
        firstPicker.delegate = self
        issueTextView.delegate = self
    }
    
    
//MARK: - Send Email
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        // Method for when the send button is pressed
        
        // Check that the user picked a subject
        let picked = firstPicker.selectedRow(inComponent: 0)
        if picked == 0 {
            resultLabel.text = "Please select a subject"
            resultLabel.alpha = 1
            resultLabel.textColor = UIColor(named: "Interface")
        } else {
            
            // Create string to store reason for user contacting us
            var reason: String?
            if picked == (K.contact.pickerOptions.count + 1) {
                reason = "Other"
            } else {
                reason = K.contact.pickerOptions[picked]
            }
            
            // Create mailCompose VC
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            
            // Get message from text view and check it exists
            let message =  issueTextView.text
            if message == nil || message == "" {
                resultLabel.text = "Please include a message so we can help you."
                resultLabel.alpha = 1
                resultLabel.textColor = UIColor(named: "Interface")
            } else {
                
                // Create email using variables and present mailCompose VC
                mc.mailComposeDelegate = self
                mc.setToRecipients(S.contactUsAddresses)
                mc.setSubject("iOS report - \(reason!)")
                mc.setMessageBody("Subject: \(reason!)\n\nIssue: \(message!)", isHTML: false)
                self.present(mc, animated: true) {
                }
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Method to handel various completions of the mailCompose VC using a switch statement
        
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
            issueTextView.text = ""
        
        default:
            resultLabel.alpha = 0
            break
        }
        
        // Dismiss mailCompose VC
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: - Picker View

extension ContactUsViewController: UIPickerViewDataSource {
    
    // Methods to set up the picker view data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return K.contact.pickerOptions.count + 2
    }
    
    
}

extension ContactUsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Method to populate the picker view's rows
        
        if row == 0 {
            return "Please Select an Option"
        }else if row == K.contact.pickerOptions.count + 1 {
            return "Other"
        } else {
            return K.contact.pickerOptions[row - 1]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Method to alter the label above the text view depending on the users choice
        if row == 2 {
            placeholderLabel.text = "Requested book must be from Project Gutenberg"
        } else {
            placeholderLabel.text = "Message:"
        }
    }
}


//MARK: - Audio Book Control

extension ContactUsViewController {
    // Audio book navigation bar controls
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if SpeechService.shared.renderStopButton() {
            bookStopButton.image = UIImage(systemName: "play.slash")
        } else {
            bookStopButton.image = nil
        }
    }
    
    
    @IBAction func bookStopButtonPressed(_ sender: UIBarButtonItem) {
        SpeechService.shared.stopSpeeching()
        bookStopButton.image = nil
    }
    
}

