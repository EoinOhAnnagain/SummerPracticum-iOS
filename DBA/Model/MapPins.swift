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
    let titleGa: String
    let routes: String
    let stopNumber: Int
    
}

