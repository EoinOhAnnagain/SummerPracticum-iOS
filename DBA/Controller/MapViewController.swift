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
    
    @IBOutlet weak var legalButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
    var userLocation: CLLocationCoordinate2D?
    var radius: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCorners(buttons)
        
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
        mapView.camera = camera
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
        mapView.animate(toViewingAngle: 45)
              
              
        locationManager.stopUpdatingLocation()
        
        if nearMeChosen {
            generateStopsNearMePins()
        } else {
            generateRouteStopPins(mapView)
        }
        
        
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //        locationManager.delegate = self
    //        locationManager.startUpdatingLocation()
    //    }
    
    
    func generateRouteStopPins(_ mapView: GMSMapView) {
        for stop in K.stopsLocations {
            for route in stop.busesAtStop {
                if route == chosenRoute {
                    let stopMarker = GMSMarker()
                    stopMarker.position = CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.long)
                    stopMarker.icon = UIImage(systemName: "bus.doubledecker", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
                    stopMarker.title = stop.titleEn
                    stopMarker.snippet = "Stop Number: \(stop.stopNumber)\n\(stop.routes.trimmingCharacters(in: .whitespaces))"
                    stopMarker.map = mapView
                }
            }
        }
    }
    
    func generateStopsNearMePins() {
        mapView.clear()
        let region = CLCircularRegion(center: userLocation!, radius: radius, identifier: "RegionID")
        for stop in K.stopsLocations {
            if region.contains(CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.long)) {
                let stopMarker = GMSMarker()
                stopMarker.position = CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.long)
                stopMarker.icon = UIImage(systemName: "bus.doubledecker", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
                stopMarker.title = stop.titleEn
                stopMarker.snippet = "Stop Number: \(stop.stopNumber)\n\(stop.routes.trimmingCharacters(in: .whitespaces))"
                stopMarker.map = mapView
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
            nearMeControlsView.alpha = 1
        }
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
}


//MARK: - Near Me Controls

extension MapViewController {
    
    @IBAction func hideNearMeControls(_ sender: UIButton) {
        nearMeControlsView.alpha = 0
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
