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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        GMSServices.provideAPIKey(S.googleMapsAPIKey)
        
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
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16.0)
        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.clear()
        view.addSubview(mapView)
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        let userLocation = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.position = userLocation
        marker.title = "You Are Here"
        marker.snippet = ":)"
        marker.icon = UIImage(systemName: "figure.wave.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        marker.map = mapView
        locationManager.stopUpdatingLocation()
        
        if nearMeChosen {
            generateStopsNearMePins(mapView, userLocation)
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
                    stopMarker.snippet = stop.routes
                    stopMarker.map = mapView
                }
            }
        }
    }
    
    func generateStopsNearMePins(_ mapView: GMSMapView, _ userLocation: CLLocationCoordinate2D) {
        
        let region = CLCircularRegion(center: userLocation, radius: 1000.0, identifier: "RegionID")
        for stop in K.stopsLocations {
            if region.contains(CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.long)) {
                let stopMarker = GMSMarker()
                stopMarker.position = CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.long)
                stopMarker.icon = UIImage(systemName: "bus.doubledecker", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
                stopMarker.title = stop.titleEn
                stopMarker.snippet = stop.routes
                stopMarker.map = mapView
            }
        }
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
