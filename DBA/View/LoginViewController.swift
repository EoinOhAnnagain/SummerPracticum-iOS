//
//  LoginViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 28/06/2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import CoreLocation

class LoginViewController: UIViewController, UISearchTextFieldDelegate {
    
    // IBOutlets
    // Nav Bar Button
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    // Login Outlets
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    // Sign Up Outlets
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpSecondPasswordTextField: UITextField!
    
    // Info Label Outlet
    @IBOutlet weak var infoLabel: UILabel!
    
    // Title Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    
    // Outlet Collections
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var labels: [UILabel]!
    
    // Variable for route names
    var routeNames: [String] = []
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // Set status bar style
        .darkContent
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If a user is logged in log them out
        logOut()
        
        // Roud corners of various objects
        roundCorners(buttons)
        roundCorners(labels)
        
        // Animate the title
        title()
        
        // Set delegates
        loginEmailTextField.delegate = self
        loginPasswordTextField.delegate = self
        signUpEmailTextField.delegate = self
        signUpPasswordTextField.delegate = self
        signUpSecondPasswordTextField.delegate = self
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
                
                Auth.auth().signIn(withEmail: email, password: password) { [self] authResult, error in
                    if let e = error {
                        self.infoLabel.text = e.localizedDescription
                    } else {
                        if Auth.auth().currentUser!.isEmailVerified == false {
                            self.infoLabel.text = "Please verify email"
                            logOut()
                        } else {
                            self.infoLabel.text = "👍🏻"
                            self.performSegue(withIdentifier: K.loggedIn, sender: self)
                        }
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
        showAlert()
    }
    
    func signUp() {
        if let email = signUpEmailTextField.text, let password = signUpPasswordTextField.text, let password2 = signUpSecondPasswordTextField.text {
            if email != "" && password != "" && password2 != "" {
                print(password.count)
                if password.count >= 8 {
                    if password == password2 {
                        
                        self.infoLabel.text = "Signing up new user"
                        Auth.auth().createUser(withEmail: email, password: password) { AuthResult, error in
                            if let e = error{
                                print(e.localizedDescription)
                                self.infoLabel.text = e.localizedDescription
                                
                            } else {
                                
                                Auth.auth().currentUser?.sendEmailVerification { error in
                                    if let e = error{
                                        print(e.localizedDescription)
                                        self.infoLabel.text = e.localizedDescription
                                        
                                    } else {
                                        
                                        self.infoLabel.text = "👍🏻 Please check your email for a verification link"
                                        self.loginEmailTextField.text = self.signUpEmailTextField.text
                                        self.loginPasswordTextField.text = self.signUpPasswordTextField.text
                                        self.signUpPasswordTextField.text = ""
                                        self.signUpEmailTextField.text = ""
                                        self.signUpSecondPasswordTextField.text = ""
                                    }
                                    
                                }
                            }
                        }
                    } else {
                        self.infoLabel.text = "Passwords do not match"
                        self.signUpPasswordTextField.text = ""
                        self.signUpSecondPasswordTextField.text = ""
                    }
                } else {
                    self.infoLabel.text = "Password must be at least 8 characters long"
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
        
        infoLabel.text = ""
        
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




//MARK: - GDPR Alert


extension LoginViewController {
    
    func showAlert() {
        
        let alert = UIAlertController(title: K.GDPR.title, message: "\(K.GDPR.messageSignUp)\(K.GDPR.chat)\(K.GDPR.contactUs)\(K.GDPR.map)\(K.GDPR.signUp)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "\(K.GDPR.dismissSignup)", style: .cancel, handler: { action in
            self.infoLabel.text = "Did not create new user due to GDPR."
        }))
        
        alert.addAction(UIAlertAction(title: "\(K.GDPR.agreeSignUp)", style: .default, handler: { action in
            print("Agreed to GDPR")
            self.signUp()
        }))
        
        present(alert, animated: true)
    }
}
