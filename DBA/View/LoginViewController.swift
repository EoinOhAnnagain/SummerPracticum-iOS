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
    
    
//MARK: - Animations
    
    func title() {
        // Method to animate the title
        
        // Type animation for letters
        titleLabel.text = ""
        var i = 1
        let titleText = "D B A"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: TimeInterval(i)*0.3, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            i += 1
        }
        
        // Fade after 3 seconds
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            UIView.animate(withDuration: 3) {
                self.titleLabel.alpha = 0
            }
        }
    }
    
    
//MARK: - Misc (No User and Segue Override)
    
    @IBAction func guestPressed(_ sender: UIButton) {
        // Segue if guest button pressed
        performSegue(withIdentifier: K.guest, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Segue overrides
        
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
        // If user is logged in, log them out.
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("ERROR")
        }
    }
}


//MARK: - Log In

extension LoginViewController {
    
    @IBAction func loginPressed(_ sender: UIButton) {
        // Button action to call login function
        
        login()
    }
    
    func login() {
        // Function to login user
        
        // set users email and password ot variables
        if let email = loginEmailTextField.text, let password = loginPasswordTextField.text {
            
            // If email and password are not empty
            if email != "" && password != "" {
                
                // Sign in user.
                Auth.auth().signIn(withEmail: email, password: password) { [self] authResult, error in
                    
                    if let e = error {
                        
                        // Display failed login message
                        self.infoLabel.text = e.localizedDescription
                        
                    } else {
                        
                        // Check if user is verified
                        if Auth.auth().currentUser!.isEmailVerified == false {
                            
                            // If not verified print display message and log user out
                            self.infoLabel.text = "Please verify email"
                            logOut()
                            
                        } else {
                            
                            // Display success message (usually not displayed as segue is performed before user has a chance to see to just in case) and send user to main VC
                            self.infoLabel.text = "👍🏻"
                            self.performSegue(withIdentifier: K.loggedIn, sender: self)
                        }
                    }
                }
            } else {
                // Message if email or password is missing
                self.infoLabel.text = "Missing field"
            }
        }
    }
    
}

//MARK: - Sign Up

extension LoginViewController {
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        // Button action to call signUp() via showAlert() function
        showAlert()
    }
    
    func signUp() {
        // Method to sign up new user
        
        // Set user email and passowrds to variables
        if let email = signUpEmailTextField.text, let password = signUpPasswordTextField.text, let password2 = signUpSecondPasswordTextField.text {
            
            // Check that none of the fields are empty
            if email != "" && password != "" && password2 != "" {
                
                // Check that password is 8 characters or more
                if password.count >= 8 {
                    
                    // Check the passwords match
                    if password == password2 {
                        
                        // Sign up new user and inform user
                        self.infoLabel.text = "Signing up new user"
                        Auth.auth().createUser(withEmail: email, password: password) { AuthResult, error in
                            if let e = error{
                                print(e.localizedDescription)
                                self.infoLabel.text = e.localizedDescription
                                
                            } else {
                                
                                // Send user verification email
                                Auth.auth().currentUser?.sendEmailVerification { error in
                                    
                                    if let e = error{
                                        print(e.localizedDescription)
                                        self.infoLabel.text = e.localizedDescription
                                        
                                    } else {
                                        
                                        // Inform user of verification email and move the email and password to the login fields
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
                        // If passwords don't match
                        self.infoLabel.text = "Passwords do not match"
                        self.signUpPasswordTextField.text = ""
                        self.signUpSecondPasswordTextField.text = ""
                    }
                } else {
                    // If password is too short
                    self.infoLabel.text = "Password must be at least 8 characters long"
                    self.signUpPasswordTextField.text = ""
                    self.signUpSecondPasswordTextField.text = ""
                }
            } else {
                // If a field is incomplete
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
        // Method to manage the return key
        
        // Call relevent functions if certain fields
        if textField == loginPasswordTextField {
            login()
        } else if textField == signUpSecondPasswordTextField {
            showAlert()
        }
        
        // End editing and dismiss keyboard
        return view.endEditing(true)
    }
}

//MARK: - Audio Book Control

extension LoginViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Clear infoLabel
        infoLabel.text = ""
        
        // Check if a book is playing and display navigation button if one is
        if SpeechService.shared.renderStopButton() {
            bookStopButton.image = UIImage(systemName: "play.slash")
        } else {
            bookStopButton.image = nil
        }
    }
    
    @IBAction func bookStopButtonPressed(_ sender: UIBarButtonItem) {
        // Stop playing book and hide button
    
        SpeechService.shared.stopSpeeching()
        bookStopButton.image = nil
    }
}




//MARK: - GDPR Alert


extension LoginViewController {
    
    func showAlert() {
        // Function to show GDPR alert
        
        let alert = UIAlertController(title: K.GDPR.title, message: "\(K.GDPR.messageSignUp)\(K.GDPR.chat)\(K.GDPR.contactUs)\(K.GDPR.map)\(K.GDPR.signUp)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "\(K.GDPR.dismissSignup)", style: .cancel, handler: { action in
            self.infoLabel.text = "Did not create new user due to GDPR."
        }))
        
        alert.addAction(UIAlertAction(title: "\(K.GDPR.agreeSignUp)", style: .default, handler: { action in
            print("Agreed to GDPR")
            // Sign up user if GDPR agreed to
            self.signUp()
        }))
        
        present(alert, animated: true)
    }
}
