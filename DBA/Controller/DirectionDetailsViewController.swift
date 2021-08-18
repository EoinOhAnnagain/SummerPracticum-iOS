//
//  DirectionDetailsViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 15/08/2021.
//

import UIKit
import SwiftyJSON

class DirectionDetailsViewController: UIViewController {

    var directions: String?
    var faresJSON: [JSON]?
    
    @IBOutlet weak var faresTextView: UITextView!
    
    var faresString = "\n"
    var timesString = "\n"
    
    var departureTime: Int?
    var finalWalkTime: Int?
    var startTime: Int?
    var predictionTime: Int?
    
    var googlesGuess: String?
    
    @IBOutlet var views: [UIView]!
    @IBOutlet var textViews: [UITextView]!
    
    @IBOutlet weak var timesTV: UITextView!
    @IBOutlet weak var faresTV: UITextView!
    @IBOutlet weak var driectionsTV: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stringifyFares()
        
        
        
        

        roundCorners(views)
        roundCorners(textViews)
        
        // Due to how the text is prepared there is a "<" at the end that needs to be dropped.
        driectionsTV.text = String(directions!.dropLast())
        faresTV.text = faresString
    
        
        stringifyTimes()
    }
    

    func stringifyTimes() {
        
        timesString = "\n"
        
        if predictionTime != nil && startTime != nil && finalWalkTime != nil && departureTime != nil {
            print("start till bus = \(departureTime!-startTime!)")
            print("time after departure = \(predictionTime!+finalWalkTime!)")
            print("Journey will take \((departureTime!-startTime!)+predictionTime!+finalWalkTime!)")
            print("This is \(intToTime(((departureTime!-startTime!)+predictionTime!+finalWalkTime!), true))")
            
            
            timesString.append("We predict your journey will take:  \(intToTime(((departureTime!-startTime!)+predictionTime!+finalWalkTime!), true))")
            
            
            let startDateFormatter = DateFormatter()
            startDateFormatter.dateFormat = "HH:mm 'on' MMM-dd"
            let startDate = Date(timeIntervalSince1970: Double(startTime!))
            let readyStartDate = startDateFormatter.string(from: startDate)
            
            timesString.append("\n\nYour start time is \(readyStartDate).")
            
            
            let endDateFormatter = DateFormatter()
            endDateFormatter.dateFormat = "HH:mm"
            let endDate = Date(timeIntervalSince1970: Double(departureTime!+predictionTime!+finalWalkTime!))
            let readyEndDate = endDateFormatter.string(from: endDate)
            
            timesString.append("\nYour arrival time is \(readyEndDate).")
            
            timesString.append("\n\nGoogle's estimate is \(googlesGuess ?? "Unknown")")
            
            
            
        } else {
            timesString.append("\nTimes data is still being loaded or your journey may not include any buses.\nEither that or something went wrong.\nPlease exit and re-enter this page to try again.")
        }
        
        
        timesTV.text = timesString
        
    }
    
    
    func stringifyFares() {
        
        faresString = "\n"
        
        var i = 1
        
        for fare in faresJSON! {
            
            faresString.append("Fares for bus \(i)\n\n")
            i += 1
            
            for item in fare {
                
                faresString.append("\(item.1["category"]):\t\t")
                
                if item.1["category"] == "AdultCash" || item.1["category"] == "AdultLeap" {
                    faresString.append("\t\t")
                }
                
                faresString.append("\(item.1["fare"])\n")
                
            }
            
            faresString.append("\n")
            
        }
        
        if faresString == "\n" {
            faresString = "Fare data is still being loaded or your journey may not include any buses.\nEither that or something went wrong.\nPlease exit and re-enter this page to try again."
        }
    }
    
    
    
}

