//
//  MusicItem.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/19.
//

import Foundation
import MapKit

struct MusicItem: Identifiable, Hashable {
    var id = UUID()
    var musicId: String
    var latitude: Double
    var longitude: Double
    var playedCount: Int
    var songName: String
    var artistName: String
    var generagedData: String
    var imageName: String?
    var locationInfo: String?
    var desc: String?
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
}

