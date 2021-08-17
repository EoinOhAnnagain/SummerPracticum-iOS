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
            faresString = "Fare data is still being loaded or doesn't exist.\nPlease exit and re-enter page to try again."
        }
    }
    
    
    
}
