//
//  LocationManager.swift
//  MC3-BeyondThe3F
//
//  Created by jaesik pyeon on 2023/07/24.
//

import Foundation

class LocationManager{
    
    static let shared = LocationManager()
    private init(){}
    
    let loc = (latitude:37.5,longitude:127.5)
    
    func getDistance(latitude:Double,longitude:Double)->Double{
        let loc = (latitude:37.5,longitude:127.5)

        let x = (latitude - loc.latitude)*100000.0*0.884
        let y = (longitude - loc.longitude)*100000.0*1.110
        
        return pow((x*x)+(y*y),0.5)
    }
}
