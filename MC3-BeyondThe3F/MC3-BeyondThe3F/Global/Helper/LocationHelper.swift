//
//  LocationHelper.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/23.
//

import Foundation
import CoreLocation

class LocationManager {
    private init(){}
    static let shared = LocationManager()
    
    var userLocation = CLLocationCoordinate2D(latitude: 43.70564024126748,longitude: 142.37968945214223)
    let locationManager = CLLocationManager()
    
    func getLocationAuth(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        getUserCurrentLocation()
    }
    
    private func getUserCurrentLocation(){
        if let userCurrentLocation = locationManager.location?.coordinate {
            userLocation = userCurrentLocation
        }
    }
    
    func getDistance(latitude:Double,longitude:Double)->Double{
        let loc = (latitude:37.5,longitude:127.5)

        let x = (latitude - loc.latitude)*100000.0*0.884
        let y = (longitude - loc.longitude)*100000.0*1.110
        
        return pow((x*x)+(y*y),0.5)
    }
}
