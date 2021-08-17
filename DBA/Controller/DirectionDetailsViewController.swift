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
    
    var faresString = "\n"
    
    @IBOutlet weak var directionsTextView: UITextView!
    
    @IBOutlet weak var timeDetailsLabel: UILabel!
    @IBOutlet weak var fareDetailsLabel: UILabel!
    
    @IBOutlet var labels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stringifyFares()
        
        fareDetailsLabel.text = faresString
        timeDetailsLabel.text = "hello world"
        
        roundCorners(directionsTextView)
        
        // Do to how the text is prepared there is a "<" at the end that needs to be dropped.
        directionsTextView.text = String(directions!.dropLast())
        
        
        
    }
    

    func stringifyFares() {
        
        faresString = "\n"
        
        for fare in faresJSON! {
            
            for item in fare {
                
                if item.1["category"].count == 1 {
                    print("Found buggy fare data")
                    faresString = "No fare data available.\nSorry"
                    return
                }
                
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
