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
    
    var markerTitleForSegue: String?
    var markerAtcoCodeForSegue: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCorners(buttons)
        
        
        mapView.delegate = self
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
                generateStopMarker(stop)
            }
        }
    }
    
    
    func generateRouteStopPins() {
        mapView.clear()
        for stop in K.stopsLocations {
            for route in stop.busesAtStop {
                if route == chosenRoute {
                    generateStopMarker(stop)
                }
            }
        }
    }
    
    func generateStopMarker(_ stop: Pin) {
        let stopMarker = GMSMarker()
        stopMarker.position = CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.long)
        stopMarker.icon = GMSMarker.markerImage(with: .purple)
        stopMarker.title = "\(stop.titleEn)\n\(stop.stopNumber)"
        
        stopMarker.userData = stop.AtcoCode
        
        stopMarker.snippet = "Route(s): \(stop.routes.trimmingCharacters(in: .whitespaces))\n\nTap for arrival times.\nLong press for routing."
        
        stopMarker.map = mapView
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


//MARK: - Marker Events

extension MapViewController: GMSMapViewDelegate {
    
    
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("\nTAPPED MARKER\n")
        markerTitleForSegue = marker.title!
        markerAtcoCodeForSegue = (marker.userData! as! String)
        performSegue(withIdentifier: K.map.times, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.map.times {
            let destinationVC = segue.destination as! StopTimesViewController
            destinationVC.stopName = markerTitleForSegue
            destinationVC.stopAtcoCode = markerAtcoCodeForSegue
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("\nLONG PRESS INFO\n")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("\nOPENED MARKER\n")
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let view = Bundle.main.loadNibNamed("InfoWindow", owner: self, options: nil)![0] as! InfoWindow
        
        let frame = CGRect(x: 0, y: 0, width: 200, height: view.frame.height)
        view.frame = frame
        
        view.titleLabel.text = marker.title
        view.snippetLabel.text = marker.snippet
        roundCorners(view.infoView)
        
        
        
        return view
    }
}



//MARK: - JSON Times

extension MapViewController {
    
    
    
    
}
