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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        GMSServices.provideAPIKey(S.googleMapsAPIKey)
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
        
        print(chosenRoute!)
        
        
        
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
        view.addSubview(mapView)
        
        let cr: String = chosenRoute!
        
        generateStopPins(mapView, cr)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.title = "You Are Here"
        marker.snippet = ":)"
        marker.icon = UIImage(systemName: "figure.wave.circle.fill")
        marker.map = mapView
        locationManager.stopUpdatingLocation()
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //        locationManager.delegate = self
    //        locationManager.startUpdatingLocation()
    //    }
    
 
    func generateStopPins(_ mapView: GMSMapView, _ cr: String) {
        
        for stop in K.stopsLocations {
            for route in stop.busesAtStop {
                if route == cr {
                    let stopMarker = GMSMarker()
                    stopMarker.position = CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.long)
        //            stopMarker.icon = UIImage(systemName: "bus.doubledecker")
                    stopMarker.title = stop.titleEn
                    stopMarker.snippet = stop.routes
                    stopMarker.map = mapView
                }
            }
        }
    }
    

    
    
    
    
}

extension GMSMarker {
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
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
