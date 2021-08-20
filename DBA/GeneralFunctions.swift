//
//  GeneralFunctions.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 03/08/2021.
//

import Foundation
import UIKit


//MARK: - Functions for Rounder Corners of Objects


// The following functions all round the corners for various UI elements. These can be passed as a single element or an array of those elements

func roundCorners(_ toRound: [UIButton]) {
    for x in toRound {
        if (0.4 * x.bounds.size.height) > 25 {
            x.layer.cornerRadius = 25
        } else {
            x.layer.cornerRadius = 0.4 * x.bounds.size.height
        }
    }
}

func roundCorners(_ toRound: UIButton) {
    if (0.4 * toRound.bounds.size.height) > 25 {
        toRound.layer.cornerRadius = 25
    } else {
        toRound.layer.cornerRadius = 0.4 * toRound.bounds.size.height
    }
}

func roundCorners(_ toRound: UILabel) {
    if (0.4 * toRound.bounds.size.height) > 25 {
        toRound.layer.cornerRadius = 25
    } else {
        toRound.layer.cornerRadius = 0.4 * toRound.bounds.size.height
    }
}

func roundCorners(_ toRound: [UILabel]) {
    for x in toRound {
        if (0.4 * x.bounds.size.height) > 25 {
            x.layer.cornerRadius = 25
        } else {
            x.layer.cornerRadius = 0.4 * x.bounds.size.height
        }
    }
}

func roundCorners(_ toRound: [UIView]) {
    for x in toRound {
        if (0.4 * x.bounds.size.height) > 25 {
            x.layer.cornerRadius = 25
        } else {
            x.layer.cornerRadius = 0.4 * x.bounds.size.height
        }
    }
}

func roundCorners(_ toRound: UITextView) {
    if (0.4 * toRound.bounds.size.height) > 25 {
        toRound.layer.cornerRadius = 25
    } else {
        toRound.layer.cornerRadius = 0.4 * toRound.bounds.size.height
    }
}

func roundCorners(_ toRound: [UITextView]) {
    for x in toRound {
        if (0.4 * x.bounds.size.height) > 25 {
            x.layer.cornerRadius = 25
        } else {
            x.layer.cornerRadius = 0.4 * x.bounds.size.height
        }
    }
}

func roundCorners(_ toRound: UITextField) {
    if (0.4 * toRound.bounds.size.height) > 25 {
        toRound.layer.cornerRadius = 25
    } else {
        toRound.layer.cornerRadius = 0.4 * toRound.bounds.size.height
    }
}

func roundCorners(_ toRound: UIView) {
    if (0.4 * toRound.bounds.size.height) > 25 {
        toRound.layer.cornerRadius = 25
    } else {
        toRound.layer.cornerRadius = 0.4 * toRound.bounds.size.height
    }
}

func roundCorners(_ toRound: UIPickerView) {
    if (0.4 * toRound.bounds.size.height) > 25 {
        toRound.layer.cornerRadius = 25
    } else {
        toRound.layer.cornerRadius = 0.4 * toRound.bounds.size.height
    }
}

func roundCorners(_ toRound: UIImageView) {
    if (0.4 * toRound.bounds.size.height) > 25 {
        toRound.layer.cornerRadius = 25
    } else {
        toRound.layer.cornerRadius = 0.4 * toRound.bounds.size.height
    }
}


//MARK: - Time/Date

func currentTime() -> String {
    // This method returns the current time in hours and minutes
    
    let currentDateTime = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: currentDateTime)
}

func currentDate() -> String {
    // This methos returns the current date in day-month-year
    
    let currentDateTime = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yy"
    return dateFormatter.string(from: currentDateTime)
}

func currentTimePlus(_ currentOffset: Int) -> String {
    // This method returns the current time plus a passed about of time (in the form of seconds as an int) and returns a string showing the hours and minutes
    
    print("\n")
    let currentDateTime = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    print(currentDateTime)
    let currentDateTimeIncreased = currentDateTime + Double(currentOffset)
    print(currentDateTimeIncreased)
    print("\n")
    return dateFormatter.string(from: currentDateTimeIncreased)
}

func intToTime(_ seconds: Int, _ s: Bool) -> String {
    // Convert a passed int into a string displaying hours, minutes and optionally seconds
    
    var result = ""
    
    if seconds >= 3600 {
        result += "\(seconds / 3600)h "
    }
    
    result += "\((seconds % 3600) / 60)m"
    
    if s {
        result += " \((seconds % 3600) % 60)s"
    }
    
    return result
}


//MARK: - String Manipulation

func stringSplitter(_ title: String, _ sep: String) -> [String] {
    // Split the passed string into an array of strings using a second string passed as a marker
    
    return title.components(separatedBy: sep)
}


