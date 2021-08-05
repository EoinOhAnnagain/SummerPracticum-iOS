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
    
    var routeNames: [String] = []
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        logOut()
        roundCorners(buttons)
        roundCorners(labels)
        title()
        
        parseRoutesJSON()
        parseStopsJSON()
        
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

//MARK: - Get Routes

extension LoginViewController {
    
    func parseStopsJSON() {
        print("Started stops parsing")
        guard let jsonURL = Bundle.main.path(forResource: "routes", ofType: "json") else {
            print("There was an issue")
            return
        }
        guard let jsonString = try? String(contentsOf: URL(fileURLWithPath: jsonURL), encoding: String.Encoding.utf8) else {
            return
        }
        
        //jsonString
        
        
        
        do {
            
            let decodedData = try JSONDecoder().decode(routesJSONArray.self, from: Data(jsonString.utf8))
            
            
            for data in decodedData.routes {
                K.routeNames.append(data.route_short_name)
            }
            
            K.routeNames.sort()
            
            print("Parsing Complete")
            
            
//            let route_short_name = decodedData.test[0].route_short_name
//
//
//            let person = test(route_short_name: route_short_name)
//
//
//            print(person.route_short_name)
            
            
            
        } catch {
            print("Error occured when decoding: \(error.localizedDescription)\n\(error)")
        }
        
        
        
    }
}





//MARK: - Get Stops

extension LoginViewController {
    
    func parseRoutesJSON() {
        print("Started routes parsing")
        guard let jsonRoutesURL = Bundle.main.path(forResource: "stops", ofType: "json") else {
            print("There was an issue")
            return
        }
        guard let jsonRoutesString = try? String(contentsOf: URL(fileURLWithPath: jsonRoutesURL), encoding: String.Encoding.utf8) else {
            print("Uh oh")
            return
        }
        
        //jsonString
        
        
        
        do {
            
            let decodedRoutesData = try JSONDecoder().decode(stopsJSONArray.self, from: Data(jsonRoutesString.utf8))
            
            
            for data in decodedRoutesData.Stops {
                
                let lat = data.Latitude
                let long = data.Longitude
                let routeData = data.RouteData
                
                
                var nameEnglish: String?
                if data.ShortCommonName_en != nil {
                    nameEnglish = data.ShortCommonName_en
                } else {
                    nameEnglish = "UNKNOWN"
                }
                
                //let nameEnglish = data.ShortCommonName_en
                
                var nameIrish: String?
                if data.ShortCommonName_en != nil {
                    nameIrish = data.ShortCommonName_en
                } else {
                    nameIrish = "UNKNOWN"
                }
                //let nameIrish = data.ShortCommonName_ga
                
                let stopNumber = data.PlateCode
                
                let routesArray = String(routeData.filter { !" ".contains($0) }).components(separatedBy: ",")
                
                print(routesArray)
                
                
                K.stopsLocations.append(Pin(lat: CLLocationDegrees(lat), long: CLLocationDegrees(long), isStop: true, titleEn: nameEnglish!, titleGa: nameIrish!, routes: routeData, stopNumber: stopNumber, busesAtStop: routesArray))
                
            }
            
            //K.routeNames.sort()
            
            
            print("Routes Parsing Complete")
            
            
//            let route_short_name = decodedData.test[0].route_short_name
//
//
//            let person = test(route_short_name: route_short_name)
//
//
//            print(person.route_short_name)
            
            
            
        } catch {
            print("Error occured when decoding: \(error.localizedDescription)\n\(error)")
        }
        
        
        
    }
}



