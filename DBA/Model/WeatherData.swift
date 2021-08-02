//
//  WeatherData.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 30/06/2021.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let visibility: Int
    let weather: [Weather]
    let wind: Wind
    let sys: Sys
    let timezone: Double
}


struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Decodable {
    let id: Int
    let description: String
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
}

struct Sys: Decodable {
    let sunrise: Double
    let sunset: Double
}
