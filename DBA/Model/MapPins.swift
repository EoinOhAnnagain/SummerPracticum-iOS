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
    let titleEn: String
    let routes: String
    let stopNumber: Int
    
    
    let busesAtStop: [String] 
    
}

struct stopsJSONArray: Codable {
    
    let Stops: [Stops]
    
}

struct Stops: Codable {
    
    let Latitude: Float
    let Longitude: Float
    let RouteData: String
    let ShortCommonName_en: String?
    let PlateCode: Int
    
}

struct routesJSONArray: Codable {
    
    let routes: [routes]
    
}

struct routes: Codable {
    
    let route_short_name: String
    
}
