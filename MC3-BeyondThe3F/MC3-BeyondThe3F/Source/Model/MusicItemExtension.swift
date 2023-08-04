//
//  File.swift
//  MC3-BeyondThe3F
//
//  Created by jaesik pyeon on 2023/08/01.
//

import Foundation

extension MusicItem{
    var musicItemVO:MusicItemVO{
        MusicItemVO(id: self.uuid, musicId: self.musicId ?? "", latitude: self.latitude, longitude: self.longitude, playedCount: 0, songName: self.songName ?? "", artistName: self.artistName ?? "", generatedDate: self.generatedDate ?? Date(), savedImage: self.savedImage, locationInfo: self.locationInfo ?? "", desc: "")
    }
}
