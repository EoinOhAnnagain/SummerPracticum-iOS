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
//import ShimmerSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempDisplay: UILabel!
    @IBOutlet weak var degreesText: UILabel!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var weatherWidgetButton: UIButton!
    
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var gameButton: UIButton!
    
    @IBOutlet weak var weatherLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var startingPicker: UIPickerView!
    @IBOutlet weak var endingPicker: UIPickerView!
    
    
    var stops = ["81813, National Museum, Wolfe Tone Quay", "81911, Law Society, Blackhall Place", "80195, Ophaly Court, Dundrum Road", "80297 Hospital, Dundrum Road", "82502, Columbanus Road junction, Dundrum Road", "82503, Annaville Close, Dundrum Road", "82504, Taney Road, Rundrum Road", "82538, Drankfort, Dundrum Road"]
    
    
    var userEmailString: String?
    
    var weatherManager = WeatherManager()
    var weatherModel: WeatherModel?
    let locationManager = CLLocationManager()
    
    
    var weatherTimer: Timer?
    
    
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
        
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.5
        fadeTextAnimation.type = .fade
            
        navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
        navigationItem.title = "D B A"
        
        
        
        startingPicker.dataSource = self
        endingPicker.dataSource = self
        startingPicker.delegate = self
        endingPicker.delegate = self
        
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        startWeatherTimer()
        
        isUserLoggedIn()
        
        
        
    }
    
    @IBAction func bookStopButtonPressed(_ sender: UIBarButtonItem) {
        SpeechService.shared.stopSpeeching()
        navigationItem.setRightBarButton(nil, animated: true)
    }
    
    
    
    
    @IBAction func mapButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "Mappy", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.weatherSegue {
            let destinationVC = segue.destination as! WeatherViewController
            destinationVC.weather = weatherModel
        } else if segue.identifier == K.contactUs {
            let destinationVC = segue.destination as! ContactUsViewController
            if userEmailString != nil {
                destinationVC.userEmail = userEmailString
            }
        }
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
}



//MARK: - Location Management

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
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
        
        DispatchQueue.main.async {
            self.tempDisplay.text = weather.stringTemperature
            self.weatherIcon.image = UIImage(systemName: weather.conditionName)
            self.locationText.text = weather.cityName
            self.displayWeather()
            self.weatherModel = weather
        }
    }
    
    func didFailWithError(error: Error) {
        print("Error in weather manager")
        print(error)
        print()
    }
    
    func displayWeather() {
        
        self.weatherLoader.stopAnimating()
        self.weatherWidgetButton.alpha = 1
        
        UIView.animate(withDuration: 1.5) {
            self.tempDisplay.alpha = 1
            self.weatherIcon.alpha = 1
            self.degreesText.alpha = 1
            self.locationText.alpha = 1
            
        }
    }
    
    func startWeatherTimer() {
        weatherTimer?.invalidate()
        weatherTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { weatherTimer in
            self.locationManager.requestLocation()
        })
        
    }
    
    
    @IBAction func weatherWidgetButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: K.weatherSegue, sender: self)
        
    }
    
}


//MARK: - User Management

extension ViewController {
    
    func isUserLoggedIn() {
        if userEmailString != nil {
            chatButton.backgroundColor = UIColor(named: K.color)
            bookButton.backgroundColor = UIColor(named: K.color)
            gameButton.backgroundColor = UIColor(named: K.color)
        } else {
            chatButton.backgroundColor = .systemGray3
            bookButton.backgroundColor = .systemGray3
            gameButton.backgroundColor = .systemGray3
        }
    }
}

//MARK: - Alert

extension ViewController {
    
    func showProUserOnlyAlert(_ feature: String) {
        let actionSheet = UIAlertController(title: "\(feature) is a Pro User Feature", message: "We are sorry but some of our features are only available for pro users. To access this feature please either login or sign up to be a pro user.", preferredStyle: .actionSheet)
        
        
        
        actionSheet.addAction(UIAlertAction(title: "Login or Sign Up", style: .default, handler: { action in
            print("here")
            self.navigationController?.popViewController(animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
        }))
        
        
        present(actionSheet, animated: true)
        
    }
}

//MARK: - Picker View

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stops.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stops[row]
    }
    
}

