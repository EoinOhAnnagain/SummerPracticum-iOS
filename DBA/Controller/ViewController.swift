//
//  ViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 25/06/2021.
//

import UIKit
import CoreLocation
import Foundation
import Firebase

class ViewController: UIViewController {
    
    // IBOutlet for GDPR alert view
    @IBOutlet weak var GDPRView: UIView!
    
    // IBOutlet for navigation bar audio book button
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    // IBOutlets for weather widget
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempDisplay: UILabel!
    @IBOutlet weak var degreesText: UILabel!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var weatherWidgetButton: UIButton!
    @IBOutlet weak var weatherLoader: UIActivityIndicatorView!
    
    // IBOutlets for segue buttons
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var gameButton: UIButton!
    
    // IBOutlet for route picker
    @IBOutlet weak var routePickerView: UIPickerView!
    
    // UIViews
    @IBOutlet weak var weatherWidgetView: UIView!
    @IBOutlet weak var routesView: UIView!
    
    // IBOutlet collections for rounding
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var views: [UIView]!
    
    // User email if logged in
    var userEmailString: String?
    
    // Managers and models
    var weatherManager = WeatherManager()
    var weatherModel: WeatherModel?
    let locationManager = CLLocationManager()
    
    // Weather timer variable
    var weatherTimer: Timer?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round corners
        roundCorners(buttons)
        roundCorners(views)
        
        // Set delegates and datasources
        routePickerView.dataSource = self
        routePickerView.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        // Location manager permission and request location
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Start weather timer
        startWeatherTimer()
        
        // Check user is logged in
        isUserLoggedIn()
        
    }
    

    
    
//MARK: - Segues
    
    
    // Segues for other VCs. Pro features check user is logged in before performing segue or showing action sheet
    
    @IBAction func mapButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.mapSegue, sender: self)
    }
    
    @IBAction func nearMePressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.nearMe, sender: self)
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        if userEmailString == nil {
            showProUserOnlyAlert("Chat")
        } else {
            performSegue(withIdentifier: K.toChat, sender: self)
        }
    }
    
    @IBAction func toGame(_ sender: UIButton) {
        if userEmailString == nil {
            showProUserOnlyAlert("CodeBreaker")
        } else {
            performSegue(withIdentifier: K.toGame, sender: self)
        }
    }
    
    @IBAction func bookButtonPressed(_ sender: UIButton) {
        if userEmailString == nil {
            showProUserOnlyAlert("Books")
        } else {
            performSegue(withIdentifier: K.toBook, sender: self)
        }
    }
    
    @IBAction func contactUsPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.contactUs, sender: self)
    }
    
    @IBAction func aboutUsPressed(_ sender: Any) {
        performSegue(withIdentifier: K.toUs, sender: self)
    }
    
    
    // Override to set variables for segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.weatherSegue {
            let destinationVC = segue.destination as! WeatherViewController
            destinationVC.weather = weatherModel
        } else if segue.identifier == K.mapSegue {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.chosenRoute = K.routeNames[routePickerView.selectedRow(inComponent: 0)]
        } else if segue.identifier == K.nearMe {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.nearMeChosen = true
        }
    }
}



//MARK: - Location Management

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Method to update location
        
        // Get user location and send to weather manager
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.getLocalWeather(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error in location manager")
        print(error)
        print()
    }
}


//MARK: - Weather Management

extension ViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        // What to do if the weather is successfully updated
        
        DispatchQueue.main.async {
            // Set weather texts and call method to display weather
            self.tempDisplay.text = weather.stringTemperature
            self.weatherIcon.image = UIImage(systemName: weather.conditionName)
            self.locationText.text = weather.cityName
            self.displayWeather()
            self.weatherModel = weather
        }
    }
    
    func didFailWithError(error: Error) {
        // If weather fails to update
        print("Error in weather manager")
        print(error)
    }
    
    func displayWeather() {
        // Display weather method
        
        // Stop loading animation and activate button
        self.weatherLoader.stopAnimating()
        self.weatherWidgetButton.alpha = 1
        
        // Fade in text and image
        UIView.animate(withDuration: 1.5) {
            self.tempDisplay.alpha = 1
            self.weatherIcon.alpha = 1
            self.degreesText.alpha = 1
            self.locationText.alpha = 1
        }
    }
    
    func startWeatherTimer() {
        // Method to start the weather timer so weather updates once a minute
        
        // If there is a timer, deactivate it and start a new one
        weatherTimer?.invalidate()
        weatherTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { weatherTimer in
            self.locationManager.requestLocation()
        })
    }
    
    
    @IBAction func weatherWidgetButton(_ sender: UIButton) {
        // Segue to weather VC
        performSegue(withIdentifier: K.weatherSegue, sender: self)
    }
}


//MARK: - User Management

extension ViewController {
    
    func isUserLoggedIn() {
        // Check if a user is logged in and act accordingly
        
        if userEmailString != nil {
            // Colour the pro feature button and remove GDPR view
            chatButton.backgroundColor = UIColor(named: K.color)
            bookButton.backgroundColor = UIColor(named: K.color)
            gameButton.backgroundColor = UIColor(named: K.color)
            GDPRView.alpha = 0
        } else {
            // Grey the pro feature button and display the GDPR alert
            chatButton.backgroundColor = .systemGray3
            bookButton.backgroundColor = .systemGray3
            gameButton.backgroundColor = .systemGray3
            showAlert()
        }
    }
}

//MARK: - Alert

extension ViewController {
    
    func showProUserOnlyAlert(_ feature: String) {
        // Function to show action sheet if user is not a pro user
        
        // Action sheet message
        let actionSheet = UIAlertController(title: "\(feature) is a Pro User Feature", message: "We are sorry but some of our features are only available for pro users. To access this feature please either login or sign up to be a pro user.", preferredStyle: .actionSheet)
        
        // Button to direct user to VC
        actionSheet.addAction(UIAlertAction(title: "Login or Sign Up", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        // Button to dismiss
        actionSheet.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
        }))
        
        present(actionSheet, animated: true)
    }
}

//MARK: - Picker View

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Functions to manage route picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return K.routeNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return K.routeNames[row]
    }
}


//MARK: - Audio Book Control

extension ViewController {
    // Audio book navigation bar controls
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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


extension ViewController {
    
    func showAlert() {
        // Function to show GDPR alert
        
        let alert = UIAlertController(title: K.GDPR.title, message: "\(K.GDPR.messageSignUp)\(K.GDPR.chat)\(K.GDPR.contactUs)\(K.GDPR.map)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "\(K.GDPR.dismissGuest)", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
            // Dismiss VC if user does not agree
        }))
        
        alert.addAction(UIAlertAction(title: "\(K.GDPR.agreeGuest)", style: .default, handler: { action in
            print("Agreed to GDPR")
            // Show VC if user agrees
            UIView.animate(withDuration: 0.25) {
                self.GDPRView.alpha = 0
            }
        }))
        
        present(alert, animated: true)
    }
}
