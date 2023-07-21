//
//  MusicAnnotation.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/19.
//

import Foundation
import MapKit

class MusicAnnotation: NSObject, MKAnnotation {
    var id = UUID()
    var musicId: String
    var latitude: Double
    var longitude: Double
    var playedCount: Int
    var songName: String
    var artistName: String
    var generatedDate: Date
    var savedImage: String?
    var locationInfo: String?
    var desc: String?
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }

    init(id: UUID = UUID(), musicId: String, latitude: Double, longitude: Double, playedCount: Int, songName: String, artistName: String, generatedDate: Date, savedImage: String? = nil, locationInfo: String? = nil, desc: String? = nil) {
        self.id = id
        self.musicId = musicId
        self.latitude = latitude
        self.longitude = longitude
        self.playedCount = playedCount
        self.songName = songName
        self.artistName = artistName
        self.generatedDate = generatedDate
        self.savedImage = savedImage
        self.locationInfo = locationInfo
        self.desc = desc
    }
    init(_ musicItemVO: MusicItemVO) {
        self.id = musicItemVO.id
        self.musicId = musicItemVO.musicId
        self.latitude = musicItemVO.latitude
        self.longitude = musicItemVO.longitude
        self.playedCount = musicItemVO.playedCount
        self.songName = musicItemVO.songName
        self.artistName = musicItemVO.artistName
        self.generatedDate = musicItemVO.generatedDate
        self.savedImage = musicItemVO.savedImage
        self.locationInfo = musicItemVO.locationInfo
        self.desc = musicItemVO.desc
        super.init()
    }
    func getMusicItemFromAnnotation() -> MusicItemVO{
        return MusicItemVO(musicId: musicId, latitude: latitude, longitude: longitude, playedCount: playedCount, songName: songName, artistName: artistName, generatedDate: generatedDate, savedImage: savedImage, desc: desc)
    }
}
