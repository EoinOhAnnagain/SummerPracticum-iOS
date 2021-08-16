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

        print("\n\nfaresJSON\n")
        print(faresJSON!)
        
        fareDetailsLabel.text = "Fare data is still being loaded. Please exit page and try again."
        
        stringifyFares()
        
        fareDetailsLabel.text = faresString
        timeDetailsLabel.text = "hello world"
        
        print(String(directions!.dropLast()))
        
        roundCorners(directionsTextView)
        
        // Do to how the text is prepared there is a "<" at the end that needs to be dropped.
        directionsTextView.text = String(directions!.dropLast())
        
        
        
    }
    

    func stringifyFares() {
        
        faresString = "\n"
        
        for fare in faresJSON! {
            
            print("\n\nFARE\n")
            
            print(fare)
            
            for item in fare {
                
                if item.1["category"].count == 1 {
                    print("CATCH")
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
            faresString = "Fare data is still being loaded.\nPlease exit and reenter page to try again."
        }
        
//        print(faresString)
        
    }
    
    
    
}
