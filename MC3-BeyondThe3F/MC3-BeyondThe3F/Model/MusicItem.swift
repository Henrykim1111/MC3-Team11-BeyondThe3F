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
let annotaionDummyData:[MusicItem] = [
    MusicItem(musicId: "1004836383", latitude: 43.70564024126748,longitude: 142.37968945214223,playedCount: 0, songName: "BIG WAVE",artistName: "artist0",  generagedData: "", imageName: "annotaion0"),
    MusicItem(musicId: "1004836383", latitude: 43.81257464206404,longitude: 142.82112322464369,playedCount: 0, songName: "BIG WAVE",artistName: "artist0",  generagedData: "", imageName: "annotaion1"),
    MusicItem(musicId: "1004836383", latitude: 43.38416585162576,longitude: 141.7252598737476,playedCount: 0, songName: "BIG WAVE",artistName: "artist0",  generagedData: "", imageName: "annotaion2"),
    MusicItem(musicId: "1004836383", latitude: 45.29168643283501,longitude: 141.95286751470724,playedCount: 0, songName: "BIG WAVE",artistName: "artist0",  generagedData: "", imageName: "annotaion3")
]
let startRegion =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.64422936785126, longitude: 142.39329541313924), span: MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 2))
