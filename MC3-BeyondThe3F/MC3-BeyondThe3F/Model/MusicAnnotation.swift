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

    init(id: UUID = UUID(), musicId: String, latitude: Double, longitude: Double, songName: String, artistName: String, generatedDate: Date, savedImage: String? = nil, locationInfo: String? = nil, desc: String? = nil) {
        self.id = id
        self.musicId = musicId
        self.latitude = latitude
        self.longitude = longitude
        self.songName = songName
        self.artistName = artistName
        self.generatedDate = generatedDate
        self.savedImage = savedImage
        self.locationInfo = locationInfo
        self.desc = desc
    }
    init(_ musicItem: MusicItem) {
        self.musicId = musicItem.musicId ?? ""
        self.latitude = musicItem.latitude
        self.longitude = musicItem.longitude
        self.songName = musicItem.songName ?? ""
        self.artistName = musicItem.artistName ?? ""
        self.generatedDate = musicItem.generatedDate ?? Date()
        self.savedImage = musicItem.savedImage
        self.locationInfo = musicItem.locationInfo ?? ""
        self.desc = musicItem.description
        super.init()
    }
    func getMusicItemFromAnnotation() -> MusicItem{
        let persistentContainer = PersistenceController.shared.container
        let newItem = MusicItem(context: persistentContainer.viewContext)
        newItem.musicId = musicId
        newItem.latitude = latitude
        newItem.longitude = longitude
        newItem.locationInfo = locationInfo
        newItem.savedImage = savedImage
        newItem.generatedDate = generatedDate
        newItem.songName = songName
        newItem.artistName = artistName
        
        return newItem
    }
}
