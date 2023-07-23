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
    
    let locationManager = CLLocationManager()
    
    func getLocationAuth(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
