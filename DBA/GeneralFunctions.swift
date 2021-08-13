//
//  GeneralFunctions.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 03/08/2021.
//

import Foundation
import UIKit


//MARK: - Functions for Rounder Corners of Objects

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
    let currentDateTime = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: currentDateTime)
}

func currentDate() -> String {
    let currentDateTime = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yy"
    return dateFormatter.string(from: currentDateTime)
}

