//
//  WeatherModel.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 30/06/2021.
//

import Foundation

struct WeatherModel {
    
    let conditionId: Int
    let cityName: String
    let description: String
    
    
    let temperature: Double
    let feelsLike: Double
    let min: Double
    let max: Double
    let humidity: Int
    
    
    let visibility: Int
    let pressure: Int
    
    let windSpeed: Double
    let windDeg: Int
    
    let sunrise: Double
    let sunset: Double
    
    
    
    
    
    
    var stringTemperature: String {
        return String(format: "%.1f", temperature)
    }
    var stringFeelsLike: String {
        return String(format: "%.1f", feelsLike)
    }
    var stringMin: String {
        return String(format: "%.1f", min)
    }
    var stringMax: String {
        return String(format: "%.1f", max)
    }
    
    var stringWindSpeed: String {
        return String(format: "%.2f", windSpeed)
    }
    
    var sunriseTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date(timeIntervalSince1970: sunrise))
//        return dateFormatter.string(from: Date(timeIntervalSince1970: sunrise+Double(TimeZone.current.secondsFromGMT())))
    }
    var sunsetTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date(timeIntervalSince1970: sunset))
//        return dateFormatter.string(from: Date(timeIntervalSince1970: sunset+Double(TimeZone.current.secondsFromGMT())))
    }
    
    
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.rain"
        case 500...531:
            return "cloud.heavyrain"
        case 600...622:
            return "snowflake"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }

    }
    
    var degreeName: String {
        switch windDeg {
        case 23...68:
            return "NE"
        case 69...113:
            return "E"
        case 114...158:
            return "SE"
        case 159...203:
            return "S"
        case 204...248:
            return "SW"
        case 249...293:
            return "W"
        case 294...338:
            return "NW"
        default:
            return "N"
        }
    }
}

