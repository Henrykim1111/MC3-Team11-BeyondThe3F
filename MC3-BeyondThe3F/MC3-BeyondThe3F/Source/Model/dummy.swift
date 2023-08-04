//
//  dummy.swift
//  MC3-BeyondThe3F
//
//  Created by jaesik pyeon on 2023/07/24.
//

import Foundation
import MapKit

func insertDummy(){
    
    let musicItemDataModel = MusicItemDataModel.shared
    guard musicItemDataModel.musicList.count == 0 else{ return }
    
    for i in 1...10{
        musicItemDataModel.saveMusicItem(musicItemVO: MusicItemVO(musicId: "1559486071", latitude: 37.5, longitude: 127.5, playedCount: i, songName: "sampleSongName\(i)", artistName: "artist-\(i)", generatedDate: Date(), savedImage: nil, locationInfo: "포항시", desc: nil))
    }
    for i in 1...12{
        musicItemDataModel.saveMusicItem(musicItemVO: MusicItemVO(musicId: "1559486071", latitude: 38.5, longitude: 127.5, playedCount: i, songName: "sampleSongName\(i)", artistName: "artist-\(i)", generatedDate: Date(), savedImage: nil, locationInfo: "경주시", desc: nil))
    }
    for i in 1...13{
        musicItemDataModel.saveMusicItem(musicItemVO: MusicItemVO(musicId: "1559486071", latitude: 39.5, longitude: 127.5, playedCount: i, songName: "sampleSongName\(i)", artistName: "artist-\(i)", generatedDate: Date(), savedImage: nil, locationInfo: "울산시", desc: nil))
    }
    for i in 1...14{
        musicItemDataModel.saveMusicItem(musicItemVO: MusicItemVO(musicId: "sampleMusicID\(i)", latitude: 40.5, longitude: 127.5, playedCount: i, songName: "sampleSongName\(i)", artistName: "artist-\(i)", generatedDate: Date(), savedImage: nil, locationInfo: "대구시", desc: nil))
    }
    for i in 1...15{
        musicItemDataModel.saveMusicItem(musicItemVO: MusicItemVO(musicId: "sampleMusicID\(i)", latitude: 41.5, longitude: 127.5, playedCount: i, songName: "sampleSongName\(i)", artistName: "artist-\(i)", generatedDate: Date(), savedImage: nil, locationInfo: "부산시", desc: nil))
    }
    for i in 1...16{
        musicItemDataModel.saveMusicItem(musicItemVO: MusicItemVO(musicId: "sampleMusicID\(i)", latitude: 42.5, longitude: 127.5, playedCount: i, songName: "sampleSongName\(i)", artistName: "artist-\(i)", generatedDate: Date(), savedImage: nil, locationInfo: "양산시", desc: nil))
    }
}

func insertHistory(){
    let historyDataModel = HistoryDataModel()
    guard historyDataModel.history.count == 0 else{ return }
    
    for i in 1...10{
        historyDataModel.saveData(musicId: "sampleMusicId\(i)", songName: "sampleSongName\(i)")
    }
    
}

let startRegion =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5, longitude: 127), span: MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 2))
