//
//  MapViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 25/07/2021.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON

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
    @IBOutlet var views: [UIView]!
    
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var routingView: UIView!
    
    @IBOutlet weak var routingButton: UIButton!
    @IBOutlet weak var routeDetailsButton: UIButton!
    
    var userLocation: CLLocationCoordinate2D?
    var radius: Double = 1000
    let Dublin = GMSCameraPosition.camera(withLatitude: 53.29, longitude: -6.2603, zoom: 10.5)
    var locationButtonUsed = false
    
    var markerTitleForSegue: String?
    var markerAtcoCodeForSegue: String?
    
    var routeDrawn = false
    var originMarker: GMSMarker?
    var destinationMarker: GMSMarker?
    
    var directionsSansHTML: String?
    
    var faresJSON: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round corners
        roundCorners(buttons)
        
        // Set delegates
        mapView.delegate = self
        routePicker.delegate = self
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        // Set min and max days for date picker
        datePicker.minimumDate = Date()
        var days = DateComponents()
        days.day = 14
        datePicker.maximumDate = Calendar.current.date(byAdding: days, to: Date())
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
        
        
        
        //mapView.isMyLocationEnabled = true
        
        
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
        
        stopMarker.snippet = "Route(s): \(stop.routes.trimmingCharacters(in: .whitespaces))\n\nTap for routing.\nLong press for arrival times."
        
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
        mapView.clear()
        print("\nLONG PRESS INFO\n")
        print(marker.position.latitude)
        print(marker.position.longitude)
        originMarker = marker
        originMarker!.icon = GMSMarker.markerImage(with: .green)
        originMarker!.map = mapView
        
        routingButton.alpha = 0
        routeDetailsButton.alpha = 0
        destinationLabel.text = "Destination: Tap the map to place a destination pin"
        
        let title = marker.title
        
        routingView.alpha = 1
        
        let titleArray = stringSplitter(title!, "\n")
        
        originLabel.text = "Origin: \(titleArray[0]) - \(titleArray[1])"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.map.times {
            let destinationVC = segue.destination as! StopTimesViewController
            destinationVC.stopName = markerTitleForSegue
            destinationVC.stopAtcoCode = markerAtcoCodeForSegue
        } else if segue.identifier == K.map.details {
            print(directionsSansHTML!)
            let destinationVC = segue.destination as! DirectionDetailsViewController
            destinationVC.directions = directionsSansHTML!
            destinationVC.faresJSON = faresJSON
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("\nTAPPED MARKER\n")
        markerTitleForSegue = marker.title!
        markerAtcoCodeForSegue = (marker.userData! as! String)
        performSegue(withIdentifier: K.map.times, sender: self)
        
    }
    
//    func locationName(_ title: String) -> String {
//        let result = title.components(separatedBy: "\n")
//        return  "\(result[0]) - \(result[1])"
//    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //        if routeDrawn {
        //            routeDrawn = false
        //            if nearMeChosen {
        //                generateStopsNearMePins()
        //            } else {
        //                generateRouteStopPins()
        //            }
        //        }
        
        //        if destinationMarker != nil {
        //            destinationMarker!.map = nil
        //        }
        
        if originMarker == nil {
            return
        }
        
        mapView.clear()
        
        originMarker!.icon = GMSMarker.markerImage(with: .green)
        originMarker!.map = mapView
        
        let marker = GMSMarker()
        
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.isTappable = false
        marker.map = mapView
        
        destinationMarker = marker
        
        
        destinationLabel.text = "Destination chosen.\nOptional: Choose a departure date/time"
        UIView.animate(withDuration: 0.25) {
            self.routingButton.alpha = 1
            self.routeDetailsButton.alpha = 0
        }
        
    }
    
    @IBAction func routingButtonPressed(_ sender: UIButton) {
        getDirections(originMarker!, destinationMarker!)
    }
    
    @IBAction func routeDetailsButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: K.map.details, sender: self)
        
    }
    //    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    //        print("\nOPENED MARKER\n")
    //
    //        return false
    //    }
    
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



//MARK: - Routing

extension MapViewController {
    
    
    func getDirections(_ source: GMSMarker, _ destination: GMSMarker) {
        
        faresJSON = []
        
        var url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.position.latitude),\(source.position.longitude)"
        
        url.append("&destination=\(destination.position.latitude),\(destination.position.longitude)")
        
        url.append("&key=\(S.googleMapsAPIKey)&mode=transit&%20transit_mode=bus&transit_routing_preference=fewer_transfers")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy 'at' HH:mm"
        let formattedDate = dateFormatter.string(from: datePicker.date)
        
        //dateFormatter.timeZone = NSTimeZone(name: "IST") as TimeZone?
        
        url.append("&departure_time=\(Int(datePicker.date.timeIntervalSince1970))")
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let reFormattedDate = dateFormatter.string(from: datePicker.date)
        
        
        
        print("\n\n\(url)\n\n")
        
        AF.request(url).responseJSON { (response) in
            guard let data = response.data else {
                return
            }
            
            do {
                let jsonData = try JSON(data: data)

                
                
                let status = jsonData["status"].stringValue
                print(status)
                
                if status == "OK" {
                    
                    let routes = jsonData["routes"].arrayValue
                    
                    var directions = ""
                    
                    for route in routes {
                        let overview_polyline = route["overview_polyline"].dictionary
                        let points = overview_polyline?["points"]?.string
                        if (points != nil) {
                            let path = GMSPath.init(fromEncodedPath: points ?? "")
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeColor = .systemPurple
                            polyline.strokeWidth = 5
                            polyline.map = self.mapView
                            
                            self.routeDrawn = true
                            
                            let legs = route["legs"].arrayValue
                            
                            for leg in legs {
                                let steps = leg["steps"].arrayValue
                                
                                //
                                
                                
                                
                                
                                
                                for step in steps {
                                    let html_instructions = step["html_instructions"].string
                                    
                                    directions.append(html_instructions ?? "Missing Instructions")
                                    directions.append("\n")
                                    
                                    let steps2 = step["steps"].arrayValue
                                    
                                    if step["travel_mode"].string == "TRANSIT" {
                                        print("TRANSIT")
                                        
                                        let transitDetails = step["transit_details"].dictionary
                                        
                                        let stopsNumber = transitDetails!["num_stops"]!.int
                                        let routeNumber = transitDetails!["line"]!["short_name"].string
                                        let startStop = transitDetails!["departure_stop"]!["name"].string
                                        
                                        
                                        directions.append("Your bus is the \(routeNumber!) from stop \(stopsNumber!) - \(startStop!)\n")
                                        
                                        print("AT THE FUNCTIONS")
                                        self.postDataFare(stopsNumber!, routeNumber!)
                                        self.postDataTravelTimes(stopsNumber!, routeNumber!, startStop!, reFormattedDate)
                                        
                                    } else {
                                        print("NOT-TRANSIT")
                                    }
                                    
                                    for step2 in steps2 {
                                        let html_instructions2 = step2["html_instructions"].string
                                        
                                        directions.append("  \(html_instructions2 ?? "Missing Instructions")")
                                        directions.append("\n")
                                    }
                                    directions.append("\n")
                                }
                                
                                
                            }
                            
                            let alteredDirections = stringSplitter(directions, "<div")
                            var directionsPreped = "\n"
                            
                            for i in alteredDirections {
                                directionsPreped.append(i)
                                directionsPreped.append("\n  <")
                            }
                            
                            self.directionsSansHTML = directionsPreped.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                            
                            
                            
                            self.destinationLabel.text = "Showing Route for \(formattedDate)\nDetails available"
                            
                            UIView.animate(withDuration: 0.25) {
                                self.routeDetailsButton.alpha = 1
                            }
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                } else {
                    self.destinationLabel.text = "Sorry.\nNo routes are available."
                }
                
            } catch let error {
                print(error.localizedDescription)
                self.destinationLabel.text = "Sorry.\nSomething went  wrong."
            }
            
            
        }
        
        
        
    }
    
    @IBAction func hideRoutingView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.routingView.alpha = 0
        }
        
        if nearMeChosen {
            generateStopsNearMePins()
        } else {
            generateRouteStopPins()
        }
        
        originMarker = nil
        
        
    }
    
    
    
}

//MARK: - Backend

extension MapViewController {
    
    func postDataFare(_ stopsNumber: Int, _ routeNumber: String) {
        
        let json: [String: Any] = ["param_1": String(stopsNumber), "param_2": routeNumber]

        if JSONSerialization.isValidJSONObject(json) {
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            let url = URL(string: "http://173.82.208.22:8000/core/Fare")!
            
            var request = URLRequest(url: url)

            request.httpMethod = "POST"

            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
                
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                
                do {
                    let parsedJSON = try JSON(data: data)
                    
                    
                    self.faresJSON.append(parsedJSON)
                    
                } catch {
                    print("NOPE")
                }
                
            }
            
            task.resume()
            
        } else {
            print("Bad JSON")
        }
    }
    
    
    func postDataTravelTimes(_ stopsNumber: Int, _ routeNumber: String, _ startStop: String, _ journeyDate: String) {
        
        let json: [String: Any] = ["param_1": String(stopsNumber), "param_2": routeNumber, "param_3": startStop, "param_4": journeyDate]

//        print("\n\n")
//        print("here0")
//        print("\nJSON:\n\(json)")
        if JSONSerialization.isValidJSONObject(json) {
//            print("here1")
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
//            print("here2")
            let url = URL(string: "http://173.82.208.22:8000/core/Travel")!
//            print("here3")
            var request = URLRequest(url: url)
//            print("here4")
            request.httpMethod = "POST"
//            print("here5")
            request.httpBody = jsonData
//            print("here6")
//            print("\nJSON DATA:\n\(jsonData)\n")
            let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
//                print("here7")
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
//                print("here8")
                let stringInt = String.init(data: data, encoding: String.Encoding.utf8)
                let int = Int.init(stringInt!)
//                print("here9")
                
//                print("\nResponse:\n\(response)\n")
                print("\ndata:\n\(data)\n")
                print("\nstringInt:\n\(stringInt)\n")
                print("\nint:\n\(int)\n")
                
            }
            
            task.resume()
            
        } else {
            print("Bad JSON")
        }
    }
    
}
