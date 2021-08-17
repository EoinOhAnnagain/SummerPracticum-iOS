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
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var conductButton: UIButton!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    var chosenChat: String = "messages"
    
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    @IBOutlet weak var chatPickerView: UIView!
    @IBOutlet weak var chatPicker: UIPickerView!
    
    @IBOutlet var views: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        roundCorners(chatPicker)
        roundCorners(views)
        roundCorners(conductButton)
        
        loadMessages()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        chatPicker.dataSource = self
        chatPicker.delegate = self
        
        messageTextField.delegate = self
        
        tableView.register(UINib(nibName: K.chat.chatNib, bundle: nil), forCellReuseIdentifier: K.chat.chatCellID)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func conductButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.chat.segueToConduct, sender: self)
    }
    
    
    
    func loadMessages() {
        db.collection(chosenChat).order(by: K.chat.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print(e.localizedDescription)
            } else {
                
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    if snapshotDocuments.count == 0 {
                        let newMessage =  Message(sender: "Debug", body: "This chat is currently empty...\nWhy not be the first to post", date: 0)
                        self.messages.append(newMessage)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                        }
                        
                        
                        
                    } else {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let messageSender = data[K.chat.FStore.senderField] as? String, let messageText = data[K.chat.FStore.textField] as? String, let messageDate = data[K.chat.FStore.dateField] {
                                let newMessage = Message(sender: messageSender, body: messageText, date: messageDate as! NSNumber)
                                self.messages.append(newMessage)
                                
                                
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//MARK: - Table View Data Source

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.chat.chatCellID, for: indexPath) as! ChatCell
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftSpeechBubble.isHidden = true
            cell.rightSpeechBubble.isHidden = false
            
            cell.chatBubble.backgroundColor = UIColor.clear
            cell.label.textColor = UIColor(named: K.color)
            cell.chatBubble.layer.borderWidth = 3
            cell.chatBubble.layer.borderColor = UIColor(named: K.color)?.cgColor
        } else {
            cell.rightSpeechBubble.isHidden = true
            cell.leftSpeechBubble.isHidden = false
            
            cell.chatBubble.backgroundColor = UIColor(named: K.color)
            cell.label.textColor = UIColor.black
            cell.chatBubble.layer.borderWidth = 0
            cell.chatBubble.layer.borderColor = UIColor.clear.cgColor
        }
        
        if S.admins.contains(message.sender) {
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
        
        
        let messageDate = messages[indexPath.row].date
        
        
        let formattedDate = dateFormatter(messageDate)
        let formattedTime = timeFormatter(messageDate)
        infoLabel.text = "Message sent at \(formattedTime) on \(formattedDate)"
        infoLabel.alpha = 1
        infoLabel.textColor = .lightGray
    }
    
    func dateFormatter(_ unformatted: NSNumber) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(truncating: unformatted)))
    }
    
    func timeFormatter(_ unformatted: NSNumber) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(truncating: unformatted)))
    }
}


//MARK: - Picker View Data Source

extension ChatViewController: UIPickerViewDataSource {
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
        textFieldShouldReturn(messageTextField)
        
        UIView.animate(withDuration: 0.25) {
            self.chatPickerView.alpha = 1
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if component == 0 {
            if row == 0 {
                return "Route"
            } else {
                return K.routeNames[row-1]
            }
        } else {
            
            if row == 0 {
                return "Diresction:"
            } else if row == 1 {
                return "Inbound"
            } else {
                return "Outbound"
                
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerView.reloadComponent(1)
        
        let chosenRouteNumber = pickerView.selectedRow(inComponent: 0)
        let chosenRoute: String?
        
        if chosenRouteNumber == 0 {
            return
        } else {
            chosenRoute = K.routeNames[chosenRouteNumber-1]
            
            
            let chosenDirectionNumber = pickerView.selectedRow(inComponent: 1)
            let chosenDirection: String?
            
            if chosenDirectionNumber == 0 {
                return
            } else {
                
                if chosenDirectionNumber == 1 {
                    chosenDirection = "In"
                    chatName.text = "Route \(chosenRoute!): Inbound"
                } else {
                    chosenDirection = "Out"
                    chatName.text = "Route \(chosenRoute!): Outbound"
                }
                
                
                
                chosenChat = "\(chosenRoute!)\(chosenDirection!)"
                
                
                print(chosenChat)
                loadMessages()
            }
            
        }
    }
    
    @IBAction func checkmarkButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.chatPickerView.alpha = 0
        }
    }
    
    @IBAction func generalButtonPressed(_ sender: UIButton) {
        chosenChat = "messages"
        chatName.text = "General Messages"
        loadMessages()
    }
    
}

// MARK: - Manage Return Key and Send Messages

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        send()
        return view.endEditing(true)
    }
    
    func send() {
        
        if let messageText = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            if messageText != "" {
                if profanityFilter(messageText.lowercased()) {
                    infoLabel.text = "Your message may not contain profanity"
                    infoLabel.textColor = .red
                    infoLabel.alpha = 1
                } else {
                    db.collection(chosenChat).addDocument(data: [
                        K.chat.FStore.senderField: messageSender,
                        K.chat.FStore.textField: messageText,
                        K.chat.FStore.dateField: Int(Date().timeIntervalSince1970)
                    ]) { (error) in
                        if let e = error {
                            print(e.localizedDescription)
                        } else {
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
        send()
        view.endEditing(true)
    }
    
    func profanityFilter(_ text: String) -> Bool {
        for i in K.chat.bannedWords {
            let regex = "(?=.*\(i)*)"
            if (text.range(of:regex, options: .regularExpression) != nil) {
                return true
            }
        }
        return false
    }
    
}



extension ChatViewController {
    
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
