//
//  MusicPlayer.swift
//  MC3-BeyondThe3F
//
//  Created by jaesik pyeon on 2023/07/26.
//

import Foundation
import MusicKit
import MediaPlayer

protocol MusicPlayerProtocol{
    func musicPlayer(index:Int)
}

class MusicPlayer: ObservableObject{
    static let shared = MusicPlayer()
    
    var delegate:MusicPlayerProtocol?
    
    @Published var isPlaying: Bool = false
    @Published var playState: MPMusicPlaybackState = .paused
    @Published var musicInPlaying: MusicItemVO?
  
    let player = MPMusicPlayerController.applicationMusicPlayer
    var persistentContainer = PersistenceController.shared.container

    private init() {
           NotificationCenter.default.addObserver(
            self, selector: #selector(handleNowPlayingItemDidChange), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
   }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

   @objc private func handleNowPlayingItemDidChange() {
       musicInPlaying = playlist[self.player.indexOfNowPlayingItem]
   }
    
    
    
    var indexOfNowPlayingItem:Int{ player.indexOfNowPlayingItem }
    
    @Published var playlist:[MusicItemVO] = []{
        didSet{
            self.player.setQueue(with: self.playlist.map{$0.musicId})
            self.player.play()
            self.playState = .playing

        }
    }
    
    
    
    var isLast:Bool{
        self.player.indexOfNowPlayingItem == playlist.count - 1 ? true : false
    }
    

    var currentMusicItem:MusicItemVO?{
        let current_index = self.player.indexOfNowPlayingItem
        
        return (self.playlist.isEmpty || current_index > self.playlist.count) ? nil : self.playlist[current_index]
    }
    
    var currentPlayHead:Double{
        get{
            return self.player.currentPlaybackTime
        }
        set{
            self.player.currentPlaybackTime = newValue
        }
    }
}
extension MusicPlayer{
    func previousButtonTapped(){
        if self.player.currentPlaybackTime < 5{
            self.player.skipToPreviousItem()
        }else{
            self.player.currentPlaybackTime = 0
        }
        player.play()
        self.playState = .playing
    }
    
    func playButtonTapped(){
        if self.player.currentPlaybackRate == 0{
            self.player.play()
            self.isPlaying = true
            self.playState = .playing
        }else{
            self.player.pause()
            self.isPlaying = false
            self.playState = .paused
        }
    }

    func nextButtonTapped(){
        if !isLast{
            self.player.skipToNextItem()
        }
        self.player.play()
        self.playState = .playing
    }
    func playMusicInPlaylist(_ musicId:String){
        guard let index = self.playlist.firstIndex(where: {$0.musicId == musicId}) else { return }
        let currentIndex = self.player.indexOfNowPlayingItem
        
        if index > currentIndex{
            for _ in 0..<(index - currentIndex){
                self.player.skipToNextItem()
            }
        }else{
            for _ in 0..<(currentIndex - index){
                self.player.skipToPreviousItem()

            }
        }
        self.playState = .playing
        player.play()
    }
    func insertMusicAndPlay(musicItem:MusicItemVO) {
        let currentIndex = self.player.indexOfNowPlayingItem
        if self.playlist.isEmpty{
            self.playlist = [musicItem]
        }else{
            self.playlist.insert(musicItem, at: 0)
        }
        self.playState = .playing
    }
}
