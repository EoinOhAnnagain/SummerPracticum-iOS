//
//  StopTimesViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 13/08/2021.
//

import UIKit

class StopTimesViewController: UIViewController, StopTimesManagerDelegate {
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stopTimesView: UITextView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var stopTimesManager = StopTimesManager()
    
    var stopName: String?
    var stopAtcoCode: String?
    
    var timer = Timer()
    var seconds = 0
    
    var arrivesIn = true
    var stopTimesStore: [StopTimes]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.text = stopName
        
        stopTimesManager.delegate = self
        
        stopTimesManager.getStopTimes(stopAtcoCode!)
        
        dateTimeLabel.text = "\(currentDate())\n\(currentTime())"
        
        
    }
    
    @IBAction func didChangeSegments(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            arrivesIn = true
        } else {
            arrivesIn = false
        }
        writeTimesText(stopTimesStore!)
    }
    
    
    
    
    @objc func timerStuff() {
        seconds += 1
        timerLabel.text = intToTime(seconds)
        dateTimeLabel.text = "\(currentDate())\n\(currentTime())"
    }
    
    func writeTimesText(_ stopTimes: [StopTimes]) {
        
        if stopTimes.count > 0 {
            
            self.stopTimesView.text = "\n"
            
            if arrivesIn {
                for i in stopTimes {
                    self.stopTimesView.text.append("No. \(i.route)\nArrives In\t\t\t\(i.remainingTime)\n\n\n")
                }
            } else {
                for i in stopTimes {
                    self.stopTimesView.text.append("No. \(i.route)\nArrival Time\t\t\(i.arrivalTime)\n\n\n")
                }
            }
            
            
            
            self.loader.stopAnimating()
            
            UIView.animate(withDuration: 0.5) {
                self.stopTimesView.alpha = 1
            }
            UIView.animate(withDuration: 2) {
                self.disclaimerLabel.alpha = 0.5
                self.timerLabel.alpha = 1
                self.segmentControl.alpha = 1
            }
            
        } else {
            UIView.animate(withDuration: 0.5) {
                self.stopTimesView.text = "\n\nThere are currently no upcomming busses.\n:("
                self.loader.stopAnimating()
                self.stopTimesView.alpha = 1
            }
        }
        
    }
    
    func didGetTimes(_ stopTimesManager: StopTimesManager, _ stopTimes: [StopTimes]) {
        
        
        DispatchQueue.main.async {
            
            self.stopTimesStore = stopTimes
            self.writeTimesText(stopTimes)
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StopTimesViewController.timerStuff), userInfo: nil, repeats: true)
            
        }
        
    }
    
    func didFailWithError(error: Error) {
        print("\n\nDid Fail: \(error.localizedDescription)")
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
