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
    
    // IBOutlet for navigation bar audio book button
    @IBOutlet weak var bookStopButton: UIBarButtonItem!
    
    // IBOutlet views
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var nearMeControlsView: UIView!
    @IBOutlet weak var routeControlsView: UIView!
    @IBOutlet weak var routingView: UIView!
    
    // IBOutlet buttons
    @IBOutlet weak var legalButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var routingButton: UIButton!
    @IBOutlet weak var routeDetailsButton: UIButton!
    
    // Near me IBOutlets
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    
    // Route picking IBOutlet
    @IBOutlet weak var routePicker: UIPickerView!
    
    // IBOutlet labels
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    // IBOutlet for date picker
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // IBOutlet collections to round
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var views: [UIView]!
    
    // Location manager variable
    let locationManager = CLLocationManager()
    
    // Name of chosen route
    var chosenRoute: String?
    
    // Flag to identify is the users choice from the previosu VC
    var nearMeChosen = false
    
    // Variables for setup
    var userLocation: CLLocationCoordinate2D?
    var radius: Double = 1000
    let Dublin = GMSCameraPosition.camera(withLatitude: 53.29, longitude: -6.2603, zoom: 10.5)
    var locationButtonUsed = false
    
    // Segue prep variables
    var markerTitleForSegue: String?
    var markerAtcoCodeForSegue: String?
    var directionsSansHTML: String?
    var departureTime: Int?
    var finalWalkTime: Int?
    var startTime: Int?
    var predictionTime: Int?
    var googlesGuess: String?
    var faresJSON: [JSON] = []
    
    // Roouting variables
    var routeDrawn = false
    var originMarker: GMSMarker?
    var destinationMarker: GMSMarker?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round corners
        roundCorners(buttons)
        
        // Set delegates
        mapView.delegate = self
        routePicker.delegate = self
        locationManager.delegate = self
        
        // If user picked a route display and set camera for that route
        if nearMeChosen == false {
            generateRouteStopPins()
            mapView.camera = Dublin
        }
        
        // Update users locations
        locationManager.startUpdatingLocation()
        
        // Set min and max days for date picker
        datePicker.minimumDate = Date()
        var days = DateComponents()
        days.day = 14
        datePicker.maximumDate = Calendar.current.date(byAdding: days, to: Date())
    }
    
    
//MARK: - Location Manager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        // Get user coordinates and set camera to them
        let coordinate = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 13.0)
        
        // Set camera to user of Dublin
        if nearMeChosen || locationButtonUsed {
            mapView.camera = camera
            mapView.animate(toViewingAngle: 45)
        } else {
            mapView.camera = Dublin
        }
        
        // Enable user locations display
        mapView.isMyLocationEnabled = true
        
        // Set user locaiton to variable
        userLocation = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // Stop updating the users locaitons
        locationManager.stopUpdatingLocation()
        
        // Generate stop pins depending on the how the user got the the map
        if nearMeChosen {
            generateStopsNearMePins()
        } else {
            generateRouteStopPins()
        }
        
        // Set bool to false
        locationButtonUsed = false
    }
    
    
//MARK: - Generate Markers
    
    func generateStopsNearMePins() {
        // Method to select markers within a set radius of the user and pass them to a function that will place the marker on the map
        
        mapView.clear()
        let region = CLCircularRegion(center: userLocation!, radius: radius, identifier: "RegionID")
        for stop in K.stopsLocations {
            if region.contains(CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.long)) {
                generateStopMarker(stop)
            }
        }
    }
    
    
    func generateRouteStopPins() {
        // Method to select markers along a route and pass them to a function that will place the marker on the map
        
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
        // Method to generate a marker from the passed Pin object and place it on the map
        
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
        // Segue to the Google Maps legal information
        
        performSegue(withIdentifier: K.map.legal, sender: self)
    }
    
    
    
    @IBAction func viewControllerPressed(_ sender: UIButton) {
        // Bring up the correct view depending on how the user entered this VC
        
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
        // Move the camera to the users current location
        
        locationButtonUsed = true
        locationManager.startUpdatingLocation()
    }
}


//MARK: - Near Me Controls

extension MapViewController {
    
    @IBAction func hideNearMeControls(_ sender: UIButton) {
        // Hide view when tapped
        
        UIView.animate(withDuration: 0.25) {
            self.nearMeControlsView.alpha = 0
        }
    }
    
    @IBAction func sliderDidSlide(_ sender: UISlider) {
        // Function to change the radius that markers are placed around the user as they interact with the slider
        
        let value = sender.value
        sliderLabel.text = String(format: "Showing stops within %.2fkm", (value/4))
        radius = Double(value*250)
        generateStopsNearMePins()
    }
}


//MARK: - Route Picker Controls

extension MapViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // Set numebr of components in the route picker
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Set numebr of rows in a component
        
        return K.routeNames.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Set route name displayed on a row
        
        return K.routeNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Changes to make when user selects a row
        
        chosenRoute = K.routeNames[row]
        generateRouteStopPins()
        mapView.camera = Dublin
    }
    
    @IBAction func hideRouteViewPressed(_ sender: UIButton) {
        // Hide view when tapped
        
        UIView.animate(withDuration: 0.25) {
            self.routeControlsView.alpha = 0
        }
    }
    
    
}


//MARK: - Map and Marker Events

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        // Enter routing mode when user taps a markers info window
        
        // Clear all current markers
        mapView.clear()
        
        // Place an origin marker
        originMarker = marker
        originMarker!.icon = GMSMarker.markerImage(with: .green)
        originMarker!.map = mapView
        
        // Clear labels and buttons and present the routing view
        routingButton.alpha = 0
        routeDetailsButton.alpha = 0
        destinationLabel.text = "Destination: Tap the map to place a destination pin"
        UIView.animate(withDuration: 0.25) {
            self.routingView.alpha = 1
        }
        
        // Set the origin marker title
        let title = marker.title
        
        // Split title into array
        let titleArray = stringSplitter(title!, "\n")
        
        // Set origin label text
        originLabel.text = "Origin: \(titleArray[0]) - \(titleArray[1])"
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        // Segue to stopTimes VC when marker is long pressed
        
        markerTitleForSegue = marker.title!
        markerAtcoCodeForSegue = (marker.userData! as! String)
        performSegue(withIdentifier: K.map.times, sender: self)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        // Method to place a destination marker if an origin marker has been places
        
        if originMarker == nil {
            return
        }
        
        // Clear map incase a destination marker is already placed and replace origin marker
        mapView.clear()
        originMarker!.icon = GMSMarker.markerImage(with: .green)
        originMarker!.map = mapView
        
        // Create and place destination marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.isTappable = false
        marker.map = mapView
        destinationMarker = marker
        
        // Update label and display routing button
        destinationLabel.text = "Destination chosen.\nOptional: Choose a departure date/time"
        UIView.animate(withDuration: 0.25) {
            self.routingButton.alpha = 1
            self.routeDetailsButton.alpha = 0
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // Method to display a custom info box when a stop or origin marker is tapped
        
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
        // Method to get and display routing data
        
        // Clear variable
        self.startTime = nil
        self.googlesGuess = nil
        faresJSON = []
        
        // Create URL to API
        var url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.position.latitude),\(source.position.longitude)"
        url.append("&destination=\(destination.position.latitude),\(destination.position.longitude)")
        url.append("&key=\(S.googleMapsAPIKey)&mode=transit&%20transit_mode=bus&transit_routing_preference=fewer_transfers")
        url.append("&departure_time=\(Int(datePicker.date.timeIntervalSince1970))")
        
        // Get and format chosen dateTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy 'at' HH:mm"
        let formattedDate = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let reFormattedDate = dateFormatter.string(from: datePicker.date)
        
        // Get responce from API
        AF.request(url).responseJSON { (response) in
            guard let data = response.data else {
                return
            }
            
            do {
                // Parse JSON data
                let jsonData = try JSON(data: data)

                let status = jsonData["status"].stringValue
                print(status)
                
                if status == "OK" {
                    
                    // Clear var
                    var directions = ""
                    
                    let routes = jsonData["routes"].arrayValue
                    for route in routes {
                        let overview_polyline = route["overview_polyline"].dictionary
                        let points = overview_polyline?["points"]?.string
                        if (points != nil) {
                            
                            // Draw route
                            let path = GMSPath.init(fromEncodedPath: points ?? "")
                            let polyline = GMSPolyline.init(path: path)
                            
                            // Route style
                            polyline.strokeColor = .systemPurple
                            polyline.strokeWidth = 5
                            polyline.map = self.mapView
                            
                            // Set flag
                            self.routeDrawn = true
                            
                            let legs = route["legs"].arrayValue
                            
                            for leg in legs {
                                
                                // Set start time
                                if self.startTime == nil {
                                    self.startTime = leg["departure_time"]["value"].int
                                }
                                
                                // Set Googles durations estimate
                                if self.googlesGuess == nil {
                                    self.googlesGuess = leg["duration"]["text"].string
                                }
                                
                                let steps = leg["steps"].arrayValue
                                for step in steps {
                                    
                                    // Get directsions and append to directions string
                                    let html_instructions = step["html_instructions"].string
                                    directions.append(html_instructions ?? "Missing Instructions")
                                    directions.append("\n")
                                    
                                    let steps2 = step["steps"].arrayValue
                                    
                                    // If using Transit
                                    if step["travel_mode"].string == "TRANSIT" {
                                        
                                        // Set variables from JSON
                                        let transitDetails = step["transit_details"].dictionary
                                        let stopsNumber = transitDetails!["num_stops"]!.int
                                        let routeNumber = transitDetails!["line"]!["short_name"].string
                                        let startStop = transitDetails!["departure_stop"]!["name"].string
                                        
                                        // Set departure time. It is ok to allow this to be overridden if several buses are used. Only the last bus matters
                                        self.departureTime = transitDetails!["departure_time"]!["value"].int
                                        
                                        // Add bus route and stop number to directions string
                                        directions.append("Your bus is the \(routeNumber!) from \(startStop!)\n")
                                        
                                        // Post to backend using received variables
                                        self.postDataFare(stopsNumber!, routeNumber!)
                                        self.postDataTravelTimes(stopsNumber!, routeNumber!, startStop!, reFormattedDate)
                                        
                                    // If Walking
                                    } else if step["travel_mode"].string == "WALKING" {
                                        // Only last walk matters
                                        self.finalWalkTime = step["duration"]["value"].int
                                    }
                                    
                                    for step2 in steps2 {
                                        
                                        // Append directions to string
                                        let html_instructions2 = step2["html_instructions"].string
                                        directions.append("  \(html_instructions2 ?? "Missing Instructions")")
                                        directions.append("\n")
                                    }
                                    directions.append("\n")
                                }
                            }
                            
                            // Remove HTML from directions string
                            let alteredDirections = stringSplitter(directions, "<div")
                            var directionsPreped = "\n"
                            for i in alteredDirections {
                                directionsPreped.append(i)
                                directionsPreped.append("\n  <")
                            }
                            self.directionsSansHTML = directionsPreped.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                            
                            // Update label and display button
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
    
    @IBAction func routingButtonPressed(_ sender: UIButton) {
        // Get and dispaly route
        
        mapView.clear()
        destinationMarker!.map = mapView
        originMarker!.map = mapView
        getDirections(originMarker!, destinationMarker!)
    }
    
    @IBAction func routeDetailsButtonPressed(_ sender: UIButton) {
        // Segue to details VC
        
        performSegue(withIdentifier: K.map.details, sender: self)
    }
    
    @IBAction func hideRoutingView(_ sender: UIButton) {
        // Hide routing VC and return to maps original mode
        
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


//MARK: - Segue Management

extension MapViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set variables on segue destination VCs
        
        if segue.identifier == K.map.times {
            let destinationVC = segue.destination as! StopTimesViewController
            destinationVC.stopName = markerTitleForSegue
            destinationVC.stopAtcoCode = markerAtcoCodeForSegue
        } else if segue.identifier == K.map.details {
            let destinationVC = segue.destination as! DirectionDetailsViewController
            destinationVC.directions = directionsSansHTML!
            destinationVC.faresJSON = faresJSON
            destinationVC.departureTime = departureTime
            destinationVC.finalWalkTime = finalWalkTime
            destinationVC.startTime = startTime
            destinationVC.predictionTime = predictionTime
            destinationVC.googlesGuess = googlesGuess
        }
    }
}

//MARK: - Backend

extension MapViewController {
    
    func postDataFare(_ stopsNumber: Int, _ routeNumber: String) {
        // Post to backend for fares data
        
        let json: [String: Any] = ["param_1": String(stopsNumber), "param_2": routeNumber]

        if JSONSerialization.isValidJSONObject(json) {
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            let url = URL(string: "\(S.fareURL)")!
            
            var request = URLRequest(url: url)

            request.httpMethod = "POST"

            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
                
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
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
        // Post to backend for travel times data
        
        let json: [String: Any] = ["param_1": String(stopsNumber), "param_2": routeNumber, "param_3": startStop, "param_4": journeyDate]

        if JSONSerialization.isValidJSONObject(json) {

            let jsonData = try? JSONSerialization.data(withJSONObject: json)

            let url = URL(string: "\(S.timesURL)")!

            var request = URLRequest(url: url)

            request.httpMethod = "POST"

            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in

                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }

                let stringInt = String.init(data: data, encoding: String.Encoding.utf8)
                let predictionInt = Int.init(stringInt ?? "0")
                
                predictionTime = predictionInt
                
            }
            task.resume()
        } else {
            print("Bad JSON")
        }
    }
    
}


//MARK: - Audio Book Control

extension MapViewController {
    // Audio book navigation bar controls
    
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
