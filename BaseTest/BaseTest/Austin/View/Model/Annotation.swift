//
//  Annotation.swift
//  BaseTest
//
//  Created by Seungui Moon on 2023/07/15.
//

import Foundation
import MapKit

class DefaultAnnotation: NSObject, MKAnnotation {
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

    init(id: UUID = UUID(), musicId: String, latitude: Double, longitude: Double, playedCount: Int, songName: String, artistName: String, generagedData: String, imageName: String? = nil, locationInfo: String? = nil, desc: String? = nil) {
        self.id = id
        self.musicId = musicId
        self.latitude = latitude
        self.longitude = longitude
        self.playedCount = playedCount
        self.songName = songName
        self.artistName = artistName
        self.generagedData = generagedData
        self.imageName = imageName
        self.locationInfo = locationInfo
        self.desc = desc
    }
    init(_ musicItem: MusicItem) {
        self.id = musicItem.id
        self.musicId = musicItem.musicId
        self.latitude = musicItem.latitude
        self.longitude = musicItem.longitude
        self.playedCount = musicItem.playedCount
        self.songName = musicItem.songName
        self.artistName = musicItem.artistName
        self.generagedData = musicItem.generagedData
        self.imageName = musicItem.imageName
        self.locationInfo = musicItem.locationInfo
        self.desc = musicItem.desc
        super.init()
    }
    func getMusicItemFromAnnotation() -> MusicItem{
        return MusicItem(musicId: musicId, latitude: latitude, longitude: longitude, playedCount: playedCount, songName: songName, artistName: artistName, generagedData: generagedData, imageName: imageName, desc: desc)
    }
}
