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
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    var chosenChat: String = "messages"
    
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    @IBOutlet weak var chatPicker: UIPickerView!
    
    var busStops = ["H1", "H2", "H3", "6", "1", "4", "7", "7a", "7b", "7n", "9", "11", "13", "14", "15", "15a", "15b", "15d", "16", "25", "25a", "25b", "25d", "25n", "25x", "26", "27", "27a", "27b", "27x", "29a", "29n", "31/a", "31b", "31d", "31n", "32", "32x", "33", "33s", "33n", "33x", "37", "38a", "38b", "39", "39a", "39x", "40", "40b", "40d", "40e", "41", "41b", "41c", "41x", "42", "41d", "42d", "42n", "43", "44", "44b", "46a", "46e", "46n", "47", "49", "49n", "51d", "51x", "53", "53a", "54a", "56a", "61", "65", "65b", "66", "66a", "66b", "66e", "66n", "66x", "67", "67n", "67x", "68/a", "68x", "69", "69n", "69x", "70", "70d", "70n", "77a", "77n", "77x", "79/a", "83", "84/a", "84n", "84x", "88n", "90", "116", "118", "120", "122", "123", "130", "140", "142", "145", "150", "151", "155", "747", "757"]
    
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
        
        loadMessages()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        chatPicker.dataSource = self
        chatPicker.delegate = self
        
        messageTextField.delegate = self
        
        tableView.register(UINib(nibName: K.chat.chatNib, bundle: nil), forCellReuseIdentifier: K.chat.chatCellID)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func bookStopButtonPressed(_ sender: UIBarButtonItem) {
        SpeechService.shared.stopSpeeching()
        navigationItem.setRightBarButton(nil, animated: true)
    }
    
    
    func loadMessages() {
        db.collection(chosenChat)
            .order(by: K.chat.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
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

    
    @IBAction func dismissPressed(_ sender: UIButton) {
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
            cell.leftSpeechBubble.isHidden = false
            cell.rightSpeechBubble.isHidden = true
            
            cell.chatBubble.backgroundColor = UIColor.clear
            cell.label.textColor = UIColor(named: K.color)
            cell.chatBubble.layer.borderWidth = 3
            cell.chatBubble.layer.borderColor = UIColor(named: K.color)?.cgColor
        } else {
            cell.rightSpeechBubble.isHidden = false
            cell.leftSpeechBubble.isHidden = true
            
            cell.chatBubble.backgroundColor = UIColor(named: K.color)
            cell.label.textColor = UIColor.black
            cell.chatBubble.layer.borderWidth = 0
            cell.chatBubble.layer.borderColor = UIColor.clear.cgColor
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
        infoLabel.text = "Message \(indexPath.row) sent at \(formattedTime) on \(formattedDate)"
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
            return busStops.count + 1
        } else {
            return 2
        }
    }
}




//MARK: - Picker View Delegate

extension ChatViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if component == 0 {
            if row == 0 {
                return "General"
            } else {
                return busStops[row-1]
            }
        } else {
            let selected = pickerView.selectedRow(inComponent: 0)
            if selected == 0 {
                return ""
            } else {
                if row == 0 {
                    return "Inbound"
                } else {
                    return "Outbound"
                }
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerView.reloadComponent(1)
        
        let chosenRouteNumber = pickerView.selectedRow(inComponent: 0)
        let chosenRoute: String?
        
        if chosenRouteNumber == 0 {
            chosenRoute = "messages"
        } else {
            chosenRoute = busStops[chosenRouteNumber-1]
        }
        
        let chosenDirectionNumber = pickerView.selectedRow(inComponent: 1)
        let chosenDirection: String?
        
        if chosenDirectionNumber == 0 {
            chosenDirection = "In"
        } else {
            chosenDirection = "Out"
        }
        
        
        if chosenRoute == "messages" {
            chosenChat = chosenRoute!
        } else {
            chosenChat = "\(chosenRoute!)\(chosenDirection!)"
        }
        
        print(chosenChat)
        loadMessages()
    }
}

// MARK: - Manage Return Key

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        send()
        return view.endEditing(true)
    }
    
    func send() {
        if let messageText = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            if messageText != "" {
                db.collection(chosenChat).addDocument(data: [
                    K.chat.FStore.senderField: messageSender,
                    K.chat.FStore.textField: messageText,
                    K.chat.FStore.dateField: Date().timeIntervalSince1970
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
            } else {
                print("Message is empty")
            }
        } else {
            print("Fill fields")
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        send()
    }
}
