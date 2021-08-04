//
//  LoginViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 28/06/2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class LoginViewController: UIViewController, UISearchTextFieldDelegate {
    
    
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpSecondPasswordTextField: UITextField!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var labels: [UILabel]!
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logOut()
        roundCorners(buttons)
        roundCorners(labels)
        title()
        
        loginEmailTextField.delegate = self
        loginPasswordTextField.delegate = self
        signUpEmailTextField.delegate = self
        signUpPasswordTextField.delegate = self
        signUpSecondPasswordTextField.delegate = self
        // Do any additional setup after loading the view.
        
    }
  
  
    
    func title() {
        titleLabel.text = ""
        var i = 1
        let titleText = "D B A"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: TimeInterval(i)*0.3, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            i += 1
        }
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            UIView.animate(withDuration: 3) {
                self.titleLabel.alpha = 0
            }
            
        }
    }
    
    
    @IBAction func guestPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.guest, sender: self)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.loggedIn {
            let destinationVC = segue.destination as! ViewController
            destinationVC.userEmailString = loginEmailTextField.text
        } else if segue.identifier == K.guest {
            let destinationVC = segue.destination as! ViewController
            DispatchQueue.main.async {
                destinationVC.userEmailString = nil
            }
        } else if segue.identifier == K.signedUp {
            let destinationVC = segue.destination as! ViewController
            destinationVC.userEmailString = signUpEmailTextField.text
        }
    }
    
   
    
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("ERROR")
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


//MARK: - Log In

extension LoginViewController {
    
    @IBAction func loginPressed(_ sender: UIButton) {
        login()
    }
    
    func login() {
        
        if let email = loginEmailTextField.text, let password = loginPasswordTextField.text {
            if email != "" && password != "" {
                
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        self.infoLabel.text = e.localizedDescription
                    } else {
                        self.infoLabel.text = "👍🏻"
                        self.performSegue(withIdentifier: K.loggedIn, sender: self)
                    }
                }
            } else {
                self.infoLabel.text = "Missing field"
            }
        }
    }
    
}

//MARK: - Sign Up

extension LoginViewController {
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        signUp()
    }
    
    func signUp() {
        if let email = signUpEmailTextField.text, let password = signUpPasswordTextField.text, let password2 = signUpSecondPasswordTextField.text {
            if email != "" && password != "" && password2 != "" {
                if password == password2 {
                    
                    self.infoLabel.text = "Signing up new user"
                    Auth.auth().createUser(withEmail: email, password: password) { AuthResult, error in
                        if let e = error{
                            print(e.localizedDescription)
                            self.infoLabel.text = e.localizedDescription
                            
                        } else {
                            self.infoLabel.text = "👍🏻"
                            self.performSegue(withIdentifier: K.signedUp, sender: self)
                        }
                    }
                } else {
                    self.infoLabel.text = "Passwords do not match"
                    self.signUpPasswordTextField.text = ""
                    self.signUpSecondPasswordTextField.text = ""
                }
            } else {
                self.infoLabel.text = "Incomplete fields"
                self.signUpPasswordTextField.text = ""
                self.signUpSecondPasswordTextField.text = ""
            }
        }
        
        
    }
    
}


// MARK: - Manage Return Key

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginPasswordTextField {
            login()
        } else if textField == signUpSecondPasswordTextField {
            signUp()
        }
        return view.endEditing(true)
    }
}

//MARK: - Audio Book Control

extension LoginViewController {
    
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
        navigationItem.setRightBarButton(nil, animated: true)
    }
}
