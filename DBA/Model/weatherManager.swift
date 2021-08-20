//
//  weatherManager.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 30/06/2021.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let incompleteURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(S.openWeatherAPIKey)&units=metric"
    
    func getLocalWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let weatherURL = "\(incompleteURL)&lat=\(lat)&lon=\(lon)"
        getWeather(weatherURL: weatherURL)
    }
    
    
    func getWeather(weatherURL: String) {
        
        //Create URL
        if let url = URL(string: weatherURL) {
            
            //Create URL Session
            let session = URLSession(configuration: .default)
            
            //Give the session a task
            let task = session.dataTask(with: url) {
                data, URLResponse, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //start the task
            task.resume()
        }
        
        
        
        
    }
    
    
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let description = decodedData.weather[0].description
            
            let main = decodedData.main
            let temp = main.temp
            let feelsLike = main.feels_like
            let min = main.temp_min
            let max = main.temp_max
            let humidity = main.humidity
        
            let visibility = decodedData.visibility
            let pressure = main.pressure
            
            let wind = decodedData.wind
            let speed = wind.speed
            let deg = wind.deg
            
            let sys = decodedData.sys
            let sunrise = sys.sunrise
            let sunset = sys.sunset
            
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, description: description, temperature: temp, feelsLike: feelsLike, min: min, max: max, humidity: humidity, visibility: visibility, pressure: pressure, windSpeed: speed, windDeg: deg, sunrise: sunrise, sunset: sunset)
    
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
        }
        
        return nil
    }
}
