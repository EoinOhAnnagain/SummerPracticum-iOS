//
//  StopTimes.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 12/08/2021.
//

import Foundation

struct StopTimes {
    
    let countDown: Int
    let route: String
    
    let arrivalTime: String
    
}




struct stopTimesJSON: Codable {
    
    let countDownInSeconds: Int
    let route_number: String
    let arrivalTime: String
    let timeChange: Int
    
}
