//
//  StopTimesManager.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 12/08/2021.
//

import Foundation
import GoogleMaps

protocol StopTimesManagerDelegate {
    // Protocol for VCs using the StopTimesMAnager
    func didGetTimes(_ stopTimesManager: StopTimesManager, _ stopTimes: [StopTimes])
    func didFailWithError(error: Error)
}



struct StopTimesManager {
    
    // Set the delegate
    var delegate: StopTimesManagerDelegate?
    
    // Create StopTimes URL
    let incompleteURL =  S.stopsTimesURL
    
    func getStopTimes(_ atcoCode: String) {
        // Method to use the prepared URL to get the stop times
        let preparedURL = "\(incompleteURL)\(atcoCode)/"
        getTimes(preparedURL)
    }
    
    private func getTimes(_ preparedURL: String) {
        // Use the URL to get the stop times
        
        // If the url is good do...
        if let url = URL(string: preparedURL) {
            
            // Create the session
            let session = URLSession(configuration: .default)
            
            // Do the task
            let task = session.dataTask(with: url) {
                data, URLResponse, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                // If the data is good parse the JSON
                if let safeData = data {
                    if let times = self.parseJSON(safeData) {
                        self.delegate?.didGetTimes(self, times)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    
    
    private func parseJSON(_ stopTimesData: Data) -> [StopTimes]? {
        // Method to parse the provided JSON

        let decoder = JSONDecoder()
        
        do {
            // Decode the JSON
            let decodedData = try decoder.decode([stopTimesJSON].self, from: stopTimesData)

            // Create an array of StopTimes objects
            var timesArray: [StopTimes] = []

            // For each item in the JSON array create a StopTimes object and add it to the array
            for data in decodedData {
                
                let routeNumber = data.route_number
                let countDown = data.countdown
                let countDownString = intToTime(countDown, false)
                let arrivalTime = currentTimePlus(countDown)

                let result = StopTimes(remainingTime: countDownString, route: routeNumber, arrivalTime: arrivalTime)
                timesArray.append(result)
            }

            return timesArray

        } catch {
            delegate?.didFailWithError(error: error)
        }
        return nil
    }
}
