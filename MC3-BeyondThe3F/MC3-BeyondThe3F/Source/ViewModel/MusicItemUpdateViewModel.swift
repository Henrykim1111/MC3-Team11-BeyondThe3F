//
//  MusicUpdateViewModel.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/29.
//

import SwiftUI

private let initialMusicItemVO = MusicItemVO(
    musicId: "",
    latitude: 37,
    longitude: 126,
    playedCount: 0,
    songName: "defaultSongName",
    artistName: "defaultArtistName",
    generatedDate: Date())

final class MusicItemUpdateViewModel: ObservableObject {
    @Published var musicItemshared = initialMusicItemVO
    @Published var isUpdate = false
    
    @Published var showToastAddMusic = false
    @Published var isWorkThrough = false
    @Published var showWelcomeSheet = false
    
    var isEditing = false
    static let shared = MusicItemUpdateViewModel()
    private init(){}
    
    private let musicItemDataModel = MusicItemDataModel.shared
    
    func updateCoreDate(){
        musicItemDataModel.saveMusicItem(musicItemVO: musicItemshared)
    }
    
    func updateMusicItem(musicItem: MusicItemVO) {
        self.musicItemshared = musicItem
    }
    
    func resetInitialMusicItem(){
        self.musicItemshared = initialMusicItemVO
    }
    
    func showToastAddMusicView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.showToastAddMusic = false
            }
        }
    }
}

