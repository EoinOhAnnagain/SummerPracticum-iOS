//
//  StopTimesManager.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 12/08/2021.
//

import Foundation
import GoogleMaps

protocol StopTimesManagerDelegate {
    func didGetTimes(_ stopTimesManager: StopTimesManager, _ stopTimes: [StopTimes])
    func didFailWithError(error: Error)
}



struct StopTimesManager {
    
    var delegate: StopTimesManagerDelegate?
    
    let incompleteURL =  S.stopsTimesURL
    
    func getStopTimes(_ atcoCode: String) {
        let preparedURL = "\(incompleteURL)\(atcoCode)/"
        getTimes(preparedURL)
        
    }
    
    func getTimes(_ preparedURL: String) {
        if let url = URL(string: preparedURL) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) {
                data, URLResponse, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    
                    print(safeData)
                    print("\nGot this far\n")
                    print(safeData)
                    print("\n")
                    if let times = self.parseJSON(safeData) {
                        print("Were in the endgame now")
                        print("delegate:")
                        print(self.delegate)
                        self.delegate?.didGetTimes(self, times)
                    } else {
                        print("This is a dark area")
                    }
                }
            }
            
            task.resume()
            
        }
        
        
    }
    
    
    
    
    func parseJSON(_ stopTimesData: Data) -> [StopTimes]? {

        print("here")
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode([stopTimesJSON].self, from: stopTimesData)
            print("here???")
            var timesArray: [StopTimes] = []
            
            print("decoded data")
            print(decodedData)

            for data in decodedData {
                
                let routeNumber = data.route_number
                let countDown = data.countdown
                //let arrivalTime = data.arrivalTime
                //let timeDifference = data.timeChange
                
                let countDownString = intToTime(countDown, false)
                let arrivalTime = currentTimePlus(countDown)
                
                let result = StopTimes(remainingTime: countDownString, route: routeNumber, arrivalTime: arrivalTime)
                
                timesArray.append(result)
                
            }

            print("returning array")
            print(timesArray)
            return timesArray

        } catch {
            print(error.localizedDescription)
            print(error)
            delegate?.didFailWithError(error: error)
        }

        print("returning nil")
        return nil
    }

}
