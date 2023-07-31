//
//  MusicAnnotation.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/19.
//

import Foundation
import MapKit

class MusicAnnotation: NSObject, MKAnnotation {
    var musicData: MusicItem
   
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: musicData.latitude,
            longitude: musicData.longitude)
    }

    init(_ musicItem: MusicItem) {
        self.musicData = musicItem
        
    }
}
