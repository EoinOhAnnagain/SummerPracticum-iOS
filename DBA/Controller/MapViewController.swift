//
//  MapViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 25/07/2021.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    
    var chosenRoute: String?
    var nearMeChosen = false
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var nearMeControlsView: UIView!
    @IBOutlet weak var routeControlsView: UIView!
    
    @IBOutlet weak var legalButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var routePicker: UIPickerView!
    
    @IBOutlet var buttons: [UIButton]!
    
    var userLocation: CLLocationCoordinate2D?
    var radius: Double = 1000
    let Dublin = GMSCameraPosition.camera(withLatitude: 53.29, longitude: -6.2603, zoom: 10.5)
    var locationButtonUsed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCorners(buttons)
        
        routePicker.delegate = self
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        
        
        // Do any additional setup after loading the view.
        
        
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let coordinate = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 13.0)
        
        //let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        if nearMeChosen || locationButtonUsed {
            mapView.camera = camera
            mapView.animate(toViewingAngle: 45)
        } else {
            mapView.camera = Dublin
        }
        mapView.settings.compassButton = true
        
        
        mapView.isMyLocationEnabled = true
        
        
//        mapView.settings.myLocationButton = true
//        mapView.settings.compassButton = true
//        view.addSubview(mapView)
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        userLocation = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.position = userLocation!
        marker.title = "You Are Here"
        marker.snippet = ":)"
        marker.map = mapView
        //marker.icon = UIImage(systemName: "figure.wave.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        
              
        locationManager.stopUpdatingLocation()
        
        if nearMeChosen {
            generateStopsNearMePins()
        } else {
            generateRouteStopPins()
        }
        
        locationButtonUsed = false
        
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //        locationManager.delegate = self
    //        locationManager.startUpdatingLocation()
    //    }
    
    
    func generateStopsNearMePins() {
        mapView.clear()
        let region = CLCircularRegion(center: userLocation!, radius: radius, identifier: "RegionID")
        for stop in K.stopsLocations {
            if region.contains(CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.long)) {
                let stopMarker = GMSMarker()
                stopMarker.position = CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.long)
                stopMarker.icon = UIImage(systemName: "bus.doubledecker", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
                stopMarker.title = stop.titleEn
                stopMarker.snippet = "Stop Number: \(stop.stopNumber)\n\(stop.routes.trimmingCharacters(in: .whitespaces))"
                stopMarker.map = mapView
            }
        }
    }
    
    
    func generateRouteStopPins() {
        mapView.clear()
        for stop in K.stopsLocations {
            for route in stop.busesAtStop {
                if route == chosenRoute {
                    let stopMarker = GMSMarker()
                    stopMarker.position = CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.long)
                    stopMarker.icon = UIImage(named: "busPin")
                    stopMarker.title = stop.titleEn
                    stopMarker.snippet = "Stop Number: \(stop.stopNumber)\n\(stop.routes.trimmingCharacters(in: .whitespaces))"
                    stopMarker.map = mapView
                }
            }
        }
    }
  
    
}


//MARK: - Buttons

extension MapViewController {
    
    
    @IBAction func legalButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.map.legal, sender: self)
    }
    
    
    
    @IBAction func viewControllerPressed(_ sender: UIButton) {
        if nearMeChosen {
            UIView.animate(withDuration: 0.25) {
                self.nearMeControlsView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.routeControlsView.alpha = 1
            }
            
        }
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
       
        locationButtonUsed = true
        locationManager.startUpdatingLocation()
        
    }
    
}


//MARK: - Near Me Controls

extension MapViewController {
    
    @IBAction func hideNearMeControls(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.nearMeControlsView.alpha = 0
        }
    }
    
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        let value = sender.value
        sliderLabel.text = String(format: "Showing stops within %.2fkm", (value/4))
        
        radius = Double(value*250)
        
        generateStopsNearMePins()
    }
    
}


//MARK: - Audio Book Control

extension MapViewController {
    
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


//MARK: - Route Picker Controls

extension MapViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return K.routeNames.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return K.routeNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenRoute = K.routeNames[row]
        generateRouteStopPins()
        mapView.camera = Dublin
    }
    
    @IBAction func hideRouteViewPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.routeControlsView.alpha = 0
        }
    }
    
    
}
