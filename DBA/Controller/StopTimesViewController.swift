//
//  StopTimesViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 13/08/2021.
//

import UIKit

class StopTimesViewController: UIViewController, StopTimesManagerDelegate {
    
    // IBOutlets
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stopTimesView: UITextView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    // StopTimesManager variable
    var stopTimesManager = StopTimesManager()
    
    // Variables for the stop name and AtcoCode
    var stopName: String?
    var stopAtcoCode: String?
    
    // Time variable and seconds counter
    var timer = Timer()
    var seconds = 0
    
    // Bool to store if showing arrives in or arrival time
    var arrivesIn = true
    
    // Array to store StopTimes objects
    var stopTimesStore: [StopTimes]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title and dateTime
        titleLabel.text = stopName
        dateTimeLabel.text = "\(currentDate())\n\(currentTime())"
        
        // Set delegate
        stopTimesManager.delegate = self
        
        // Use the AtcoCode to get the stop times from the stopTimesManager
        stopTimesManager.getStopTimes(stopAtcoCode!)
    }
    
    
    @IBAction func didChangeSegments(_ sender: UISegmentedControl) {
        // If the segment is changed, flip the bool and rewrite the times text
        
        if sender.selectedSegmentIndex == 0 {
            arrivesIn = true
        } else {
            arrivesIn = false
        }
        writeTimesText(stopTimesStore!)
    }
    

    @objc func timerStuff() {
        // Increate seconds counter by one second and disply elapsed time as string
        
        seconds += 1
        timerLabel.text = intToTime(seconds, true)
        dateTimeLabel.text = "\(currentDate())\n\(currentTime())"
    }
    
    func writeTimesText(_ stopTimes: [StopTimes]) {
        // Method to write the times text for the page
        
        // Check if stopTimes is empty
        if stopTimes.count > 0 {
            self.stopTimesView.text = "\n"
            
            // Check if adding arrives in or arrival times to string
            if arrivesIn {
                for i in stopTimes {
                    self.stopTimesView.text.append("No. \(i.route)\nArrives In\t\t\t\(i.remainingTime)\n\n\n")
                }
            } else {
                for i in stopTimes {
                    self.stopTimesView.text.append("No. \(i.route)\nArrival Time\t\t\(i.arrivalTime)\n\n\n")
                }
            }
            
            // Stop loading animation
            self.loader.stopAnimating()
            
            // Display text, timer, disclaimer, and segmenter
            UIView.animate(withDuration: 0.5) {
                self.stopTimesView.alpha = 1
            }
            UIView.animate(withDuration: 2) {
                self.disclaimerLabel.alpha = 0.5
                self.timerLabel.alpha = 1
                self.segmentControl.alpha = 1
            }
            
        } else {
            
            // If stopTimes is empty display relevent message
            UIView.animate(withDuration: 0.5) {
                self.stopTimesView.text = "\n\nThere are currently no upcoming buses.\n:("
                self.loader.stopAnimating()
                self.stopTimesView.alpha = 1
            }
        }
    }
    
    func didGetTimes(_ stopTimesManager: StopTimesManager, _ stopTimes: [StopTimes]) {
        // Method for successful retreival of times
        
        
        DispatchQueue.main.async {
            
            // Update variables
            self.stopTimesStore = stopTimes
            self.writeTimesText(stopTimes)
            
            // Invalidate and create new timer that updates the timer every second
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StopTimesViewController.timerStuff), userInfo: nil, repeats: true)
        }
    }

    func didFailWithError(error: Error) {
        print("\n\nDid Fail: \(error.localizedDescription)")
    }
}
