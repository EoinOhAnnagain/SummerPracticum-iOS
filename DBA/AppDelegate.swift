//
//  AppDelegate.swift
//  DBA
//
//  Created by Eoin Ó'hAnnagáin on 25/06/2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import CoreLocation
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        //Parse Stored JSON
        parseRoutesJSON()
        parseStopsJSON()
        
        //Firebase initialisation
        FirebaseApp.configure()

        //Firebase database
        let db = Firestore.firestore()
        print(db)
        
        //IQKeybaord manager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        //Google Maps API Key
        GMSServices.provideAPIKey(S.googleMapsAPIKey)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

//MARK: - Get Routes

extension AppDelegate {
    
    func parseStopsJSON() {
        // This function parses the stops JSON
        
        print("Started stops parsing")
        guard let jsonURL = Bundle.main.path(forResource: "routes", ofType: "json") else {
            print("There was an issue")
            return
        }
        guard let jsonString = try? String(contentsOf: URL(fileURLWithPath: jsonURL), encoding: String.Encoding.utf8) else {
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(routesJSONArray.self, from: Data(jsonString.utf8))
            for data in decodedData.routes {
                K.routeNames.append(data.route_short_name)
            }
            K.routeNames.sort()
            print("Parsing Complete")
            
        } catch {
            print("Error occured when decoding: \(error.localizedDescription)\n\(error)")
        }
    }
}


//MARK: - Get Stops

extension AppDelegate {
    
    func parseRoutesJSON() {
        // This function parses the routes JSON
        
        print("Started routes parsing")
        guard let jsonRoutesURL = Bundle.main.path(forResource: "stops", ofType: "json") else {
            print("There was an issue")
            return
        }
        guard let jsonRoutesString = try? String(contentsOf: URL(fileURLWithPath: jsonRoutesURL), encoding: String.Encoding.utf8) else {
            print("Uh oh")
            return
        }
        
        do {
            let decodedRoutesData = try JSONDecoder().decode(stopsJSONArray.self, from: Data(jsonRoutesString.utf8))
            for data in decodedRoutesData.Stops {
                let lat = data.Latitude
                let long = data.Longitude
                let routeData = data.RouteData
                var nameEnglish: String?
                if data.ShortCommonName_en != nil {
                    nameEnglish = data.ShortCommonName_en
                } else {
                    nameEnglish = "UNKNOWN"
                }
                
                let atcoCode = data.AtcoCode
                let stopNumber = data.PlateCode
                let routesArray = String(routeData.filter { !" ".contains($0) }).components(separatedBy: ",")
                
                K.stopsLocations.append(Pin(lat: CLLocationDegrees(lat), long: CLLocationDegrees(long), isStop: true, titleEn: nameEnglish!, routes: routeData, stopNumber: stopNumber, AtcoCode: atcoCode, busesAtStop: routesArray))
            }
            
            print("Routes Parsing Complete")
        } catch {
            print("Error occured when decoding: \(error.localizedDescription)\n\(error)")
        }
    }
}



