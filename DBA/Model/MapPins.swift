//
//  MapPins.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 04/08/2021.
//

import Foundation
import CoreLocation

struct Pin {
    // Structure to create a marker pin object for the map
    
    let lat: CLLocationDegrees
    let long: CLLocationDegrees
    let isStop: Bool
    let titleEn: String
    let routes: String
    let stopNumber: Int
    let AtcoCode: String
    let busesAtStop: [String]
}


//MARK: - JSON Decoding


// Structures to decode the bus stops JSON data

struct stopsJSONArray: Codable {
    let Stops: [Stops]
}

struct Stops: Codable {
    let Latitude: Float
    let Longitude: Float
    let RouteData: String
    let ShortCommonName_en: String?
    let PlateCode: Int
    let AtcoCode: String
}

struct routesJSONArray: Codable {
    let routes: [routes]
}

struct routes: Codable {
    let route_short_name: String
}
