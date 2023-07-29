//
//  MusicUpdateViewModel.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/29.
//

import SwiftUI

final class MusicItemUpdateViewModel: ObservableObject {
    @Published var musicItemshared = MusicItemVO(musicId: "", latitude: 37, longitude: 126, playedCount: 0, songName: "defaultSongName", artistName: "defaultArtistName", generatedDate: Date())
    let shared = MusicUpdateViewModel()
    private init(){}
    
    func updateCoreDate(){
        // TODO: CoreData update
    }
}
