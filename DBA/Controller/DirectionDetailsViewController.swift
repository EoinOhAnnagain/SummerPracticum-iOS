//
//  DirectionDetailsViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 15/08/2021.
//

import UIKit
import SwiftyJSON

class DirectionDetailsViewController: UIViewController {

    // IBOutlets for the text views
    @IBOutlet weak var timesTV: UITextView!
    @IBOutlet weak var faresTV: UITextView!
    @IBOutlet weak var driectionsTV: UITextView!
    
    // IBOutlet collections to round
    @IBOutlet var views: [UIView]!
    @IBOutlet var textViews: [UITextView]!
        
    // Strings for text views
    var timesString = "\n"
    var faresString = "\n"
    var directions: String?
    
    // Variables passed from previous VC
    var departureTime: Int?
    var finalWalkTime: Int?
    var startTime: Int?
    var predictionTime: Int?
    var googlesGuess: String?
    var faresJSON: [JSON]?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Turn passed data into a string and display it
        stringifyFares()
        stringifyTimes()
        
        // Round corners
        roundCorners(views)
        roundCorners(textViews)
        
        // Display passed direction string
        // Due to how the text is prepared there is a "<" at the end that needs to be dropped.
        driectionsTV.text = String(directions!.dropLast())
    }
    

//MARK: - Stringify

    func stringifyTimes() {
        // Method to turn the passed times data into a string and display it.
        
        timesString = "\n"
        
        // If the various variables are all not nil create the string
        if predictionTime != nil && startTime != nil && finalWalkTime != nil && departureTime != nil {
            
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
            // Alt string if there is an issue
            timesString.append("\nTimes data is still being loaded or your journey may not include any buses.\nEither that or something went wrong.\nPlease exit and re-enter this page to try again.")
            if googlesGuess != nil {
                timesString.append("\n\nGoogle's estimate is \(googlesGuess ?? "Unknown")")
            }
        }
        
        // Display the string
        timesTV.text = timesString
    }
    
    
    func stringifyFares() {
        // Method to turn the passed fare JSON(s) into a string and display it.
        
        faresString = "\n"
        
        var i = 1
        
        // Loop through the passed array(s) and create the string
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
            // If nothing has been added to the string use this alternaticve string
            faresString = "Fare data is still being loaded or your journey may not include any buses.\nEither that or something went wrong.\nPlease exit and re-enter this page to try again."
        }
        
        // Display the string
        faresTV.text = faresString
    }
}

