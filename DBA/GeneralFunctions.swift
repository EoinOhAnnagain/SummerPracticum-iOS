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
            x.layer.cornerRadius = 0.4 * x.bounds.size.height
        }
    }
    
    func roundCorners(_ toRound: [UILabel]) {
        for x in toRound {
            x.layer.cornerRadius = 0.4 * x.bounds.size.height
        }
    }
