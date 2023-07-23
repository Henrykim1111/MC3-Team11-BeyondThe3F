//
//  LocationHelper.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/23.
//

import Foundation
import CoreLocation

class LocationHelper: ObservableObject {
    private init(){}
    static let shared = LocationHelper()
    
    var userLocation = CLLocationCoordinate2D(latitude: 43.70564024126748,longitude: 142.37968945214223)
    let locationManager = CLLocationManager()
    
    func getLocationAuth(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getUserCurrentLocation(){
        if let userCurrentLocation = locationManager.location?.coordinate {
            userLocation = userCurrentLocation
        }
    }
}
