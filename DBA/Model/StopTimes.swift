//
//  StopTimes.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 12/08/2021.
//

import Foundation

struct StopTimes {
    // Structure to create an object for busses approaching a stop
    
    let remainingTime: String
    let route: String
    let arrivalTime: String
}


//MARK: - JSON Decoding

struct stopTimesJSON: Codable {
    // Structure to decode the received stop times JSON
    
    let countdown: Int
    let route_number: String
}
