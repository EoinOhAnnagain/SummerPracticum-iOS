//
//  MapPins.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 04/08/2021.
//

import Foundation
import CoreLocation

struct Pin {
    
    let lat: CLLocationDegrees
    let long: CLLocationDegrees
    let isStop: Bool
    let title: String
    let subtitle: String
    
}

struct Result: Codable {
    let data: [Routes]
}

struct Routes: Codable {
    
    let route_name: String
    
}
