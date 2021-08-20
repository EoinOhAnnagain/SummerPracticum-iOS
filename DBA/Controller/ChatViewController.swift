//
//  ChatViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 09/07/2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {
    
    // IBOutlet for navigation bar audio book button
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    // IBOutlets for chat
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var conductButton: UIButton!
    
    // IBOutlets for the chat route picker
    @IBOutlet weak var chatPickerView: UIView!
    @IBOutlet weak var chatPicker: UIPickerView!
    
    // IBOutlet collection for rounding
    @IBOutlet var views: [UIView]!
    
    // Firestore database variable
    let db = Firestore.firestore()
    
    // Array of messages for current chat
    var messages: [Message] = []
    
    // Chosen chat and listener variables
    var chosenChat: String = "messages"
    var listener: ListenerRegistration?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round corners
        roundCorners(chatPicker)
        roundCorners(views)
        roundCorners(conductButton)
        
        // Load messages
        loadMessages()
        
        // Set delegates
        tableView.dataSource = self
        tableView.delegate = self
        chatPicker.dataSource = self
        chatPicker.delegate = self
        messageTextField.delegate = self
        
        // Register cell xib
        tableView.register(UINib(nibName: K.chat.chatNib, bundle: nil), forCellReuseIdentifier: K.chat.chatCellID)
    }
    
    
    @IBAction func conductButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.chat.segueToConduct, sender: self)
    }
    
    
    
    func loadMessages() {
        // Method to laod messages
        
        // If there is currently a listener remove it
        if listener != nil {
            listener!.remove()
        }
        
        // Create listener for the current chat the user is in
        listener = db.collection(chosenChat).order(by: K.chat.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            
            // Empty messages array
            self.messages = []
            if let e = error {
                print(e.localizedDescription)
            } else {
                
                // Get a snapshot of the chats messages
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    // If the snapshot is empty display a default empty cell
                    if snapshotDocuments.count == 0 {
                        
                        // Create default message object and append to array
                        let newMessage =  Message(sender: "Debug", body: "This chat is currently empty...\nWhy not be the first to post", date: 0)
                        self.messages.append(newMessage)
                        
                        // Reload tableView and scroll to bottom
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                        }
                        
                    } else {
                        // For each entry in the snapshot, unpack it, create a new message object, and append it to the array
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let messageSender = data[K.chat.FStore.senderField] as? String, let messageText = data[K.chat.FStore.textField] as? String, let messageDate = data[K.chat.FStore.dateField] {
                                let newMessage = Message(sender: messageSender, body: messageText, date: messageDate as! NSNumber)
                                self.messages.append(newMessage)
                                
                                // Reload tableView and scroll to bottom
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                }
                                
                            } else {
                                print("oh no")
                            }
                        }
                    }
                }
            }
        }
    }
}


//MARK: - Table View Data Source

extension ChatViewController: UITableViewDataSource {
    
    // Get the cells for the table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Set the numebr of rows
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Method top create message cell
        
        // Set message text to variable
        let message = messages[indexPath.row]
        
        // Get cell from .xib
        let cell = tableView.dequeueReusableCell(withIdentifier: K.chat.chatCellID, for: indexPath) as! ChatCell
        
        // Set the cells message text
        cell.label.text = message.body
        
        // Dispaly properties for if user or other person sent the message and if sender was an admin
        if message.sender == Auth.auth().currentUser?.email {
            // If sent by user
            cell.leftSpeechBubble.isHidden = false
            cell.rightSpeechBubble.isHidden = true
            cell.leftSpeechBubble.alpha = 0
            cell.chatBubble.backgroundColor = UIColor(named: K.color)
            cell.label.textColor = UIColor.black
            cell.chatBubble.layer.borderWidth = 0
            cell.chatBubble.layer.borderColor = UIColor.clear.cgColor
        } else {
            // If sent by other
            cell.rightSpeechBubble.isHidden = false
            cell.leftSpeechBubble.isHidden = true
            cell.rightSpeechBubble.alpha = 0
            cell.chatBubble.backgroundColor = UIColor.clear
            cell.label.textColor = UIColor(named: K.color)
            cell.chatBubble.layer.borderWidth = 3
            cell.chatBubble.layer.borderColor = UIColor(named: K.color)?.cgColor
        }
        
        if S.admins.contains(message.sender) {
            // If sender is admnin
            cell.chatBubble.backgroundColor = .lightGray
            cell.label.textColor = UIColor.purple
            cell.chatBubble.layer.borderWidth = 3
            cell.chatBubble.layer.borderColor = UIColor.purple.cgColor
            
        }
        return cell
    }
}

//MARK: - Table View Delegate

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Method to dispaly the time and date a message was sent when it is tapped
        
        // Get the messages date/time since 1970
        let messageDate = messages[indexPath.row].date
        
        // Convert time since 1970 to date and time stirngs
        let formattedDate = dateFormatter(messageDate)
        let formattedTime = timeFormatter(messageDate)
        
        // Display date and time stings for the user
        infoLabel.text = "Message sent at \(formattedTime) on \(formattedDate)"
        infoLabel.alpha = 1
        infoLabel.textColor = .lightGray
    }
    
    func dateFormatter(_ unformatted: NSNumber) -> String {
        // Method to convert date to sting
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(truncating: unformatted)))
    }
    
    func timeFormatter(_ unformatted: NSNumber) -> String {
        // Method to convert time to sting
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(truncating: unformatted)))
    }
}


//MARK: - Picker View Data Source

extension ChatViewController: UIPickerViewDataSource {
    
    // Set the route picker data
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return K.routeNames.count + 1
        } else {
            return 3
        }
    }
}




//MARK: - Picker View Delegate

extension ChatViewController: UIPickerViewDelegate {
    
    @IBAction func routeButtonPressed(_ sender: UIButton) {
        // Method for pressing theroute button
        
        // Dismiss keyboard. Return value not needed
        textFieldShouldReturn(messageTextField)
        
        // Bring up route picker
        UIView.animate(withDuration: 0.25) {
            self.chatPickerView.alpha = 1
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Method to populate the route picker
        
        if component == 0 {
            if row == 0 {
                return "Route"
            } else {
                return K.routeNames[row-1]
            }
        } else {
            if row == 0 {
                return "Directions:"
            } else if row == 1 {
                return "Inbound"
            } else {
                return "Outbound"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Method to perform action when user picks a new row in a route picker component
    
        // Set Route number and create route string variable
        let chosenRouteNumber = pickerView.selectedRow(inComponent: 0)
        let chosenRoute: String?
        
        // If route nunber is zero do nothing
        if chosenRouteNumber == 0 {
            return
        } else {
            
            // Add route name to string
            chosenRoute = K.routeNames[chosenRouteNumber-1]
            
            // Set direction number and create direction string variable
            let chosenDirectionNumber = pickerView.selectedRow(inComponent: 1)
            let chosenDirection: String?
            
            // If direction nunber is zero do nothing
            if chosenDirectionNumber == 0 {
                return
            } else {
                
                // Convert numbers to relevent strings and display new chat room
                if chosenDirectionNumber == 1 {
                    chosenDirection = "In"
                    chatName.text = "Route \(chosenRoute!): Inbound"
                } else {
                    chosenDirection = "Out"
                    chatName.text = "Route \(chosenRoute!): Outbound"
                }
                
                
                // Set the new chosen chat and load its messages
                chosenChat = "\(chosenRoute!)\(chosenDirection!)"
                loadMessages()
            }
        }
    }
    
    @IBAction func checkmarkButtonPressed(_ sender: UIButton) {
        // Fade out route picker
        UIView.animate(withDuration: 0.5) {
            self.chatPickerView.alpha = 0
        }
    }
    
    @IBAction func generalButtonPressed(_ sender: UIButton) {
        // Return to the general chat room
        chosenChat = "messages"
        chatName.text = "General Messages"
        loadMessages()
    }
    
}

// MARK: - Manage Return Key and Send Messages

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Send message when return key pressed and remove keyboard
        send()
        return view.endEditing(true)
    }
    
    func send() {
        // Method to send users message
        
        // Set users message and login to variables
        if let messageText = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            
            // check if users message is empty
            if messageText != "" {
                
                // Profanity check
                if profanityFilter(messageText.lowercased()) {
                    infoLabel.text = "Your message may not contain profanity"
                    infoLabel.textColor = .red
                    infoLabel.alpha = 1
                } else {
                    
                    // Add message to database
                    db.collection(chosenChat).addDocument(data: [
                        K.chat.FStore.senderField: messageSender,
                        K.chat.FStore.textField: messageText,
                        K.chat.FStore.dateField: Int(Date().timeIntervalSince1970)
                    ]) { (error) in
                        if let e = error {
                            print(e.localizedDescription)
                        } else {
                            // Reset text field
                            print("saved data")
                            DispatchQueue.main.async {
                                self.messageTextField.text = ""
                            }
                        }
                    }
                }
            } else {
                print("Message is empty")
            }
        } else {
            print("Fill fields")
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        // Call send method when nsend button pressed
        send()
        view.endEditing(true)
    }
    
    func profanityFilter(_ text: String) -> Bool {
        // Method to check if a users message contains a baned word using regex
        for i in K.chat.bannedWords {
            let regex = "(?=.*\(i)*)"
            if (text.range(of:regex, options: .regularExpression) != nil) {
                return true
            }
        }
        return false
    }
}


//MARK: - Audio Book Control

extension ChatViewController {
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


