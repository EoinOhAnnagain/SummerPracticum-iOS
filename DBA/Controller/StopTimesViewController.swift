//
//  StopTimesViewController.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 13/08/2021.
//

import UIKit

class StopTimesViewController: UIViewController, StopTimesManagerDelegate {
    
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stopTimesView: UITextView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    var stopTimesManager = StopTimesManager()
    
    var stopName: String?
    var stopAtcoCode: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = stopName
        
        stopTimesManager.delegate = self
        
        stopTimesManager.getStopTimes(stopAtcoCode!)
        
        dateTimeLabel.text = "\(currentDate())\n\(currentTime())"
        // Do any additional setup after loading the view.
    }
    
    
    
    func didGetTimes(_ stopTimesManager: StopTimesManager, _ stopTimes: [StopTimes]) {
        
        
        DispatchQueue.main.async {
            
            if stopTimes.count > 0 {
                
                print("\n\nDid Get Times\n\n")
                
                self.stopTimesView.text = ""
                
                for i in stopTimes {
                    self.stopTimesView.text.append("No. \(i.route)\nArrives in \(i.countDown) seconds.\n\n\n")
                }
                
                self.loader.stopAnimating()
                
                UIView.animate(withDuration: 0.5) {
                    self.stopTimesView.alpha = 1
                }
                
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.stopTimesView.text = "\n\nThere are currently no upcomming busses.\n:("
                    self.loader.stopAnimating()
                    self.stopTimesView.alpha = 1
                }
            }
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
