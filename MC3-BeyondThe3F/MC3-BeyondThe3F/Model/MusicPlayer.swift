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
    
    var isPlaying: Bool = false
    
    var seek = 0
    
    let player = MPMusicPlayerController.applicationMusicPlayer

    private init(){}
    
    
    var indexOfNowPlayingItem:Int{ player.indexOfNowPlayingItem }
    
    @Published var playlist:[MusicItem] = []{
        didSet{
            self.player.setQueue(with: self.playlist.map{$0.musicId ?? ""})
            self.player.prepareToPlay {error in
                if let error = error {
                    print(error)
                } else {
                    self.player.play()
                    for _ in 0..<self.seek{
                        self.player.skipToNextItem()
                    }
                }
           }

        }
    }
    
    
    
    var isLast:Bool{
        self.player.indexOfNowPlayingItem == playlist.count - 1 ? true : false
    }
    

    var currentMusicItem:MusicItem?{
        (self.playlist.isEmpty || self.player.indexOfNowPlayingItem > self.playlist.count) ? nil : self.playlist[self.player.indexOfNowPlayingItem]
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
    }
    
    func playButtonTapped(){
        if self.player.currentPlaybackRate == 0{
            self.player.play()
            self.isPlaying = true
        }else{
            self.player.pause()
            self.isPlaying = false
        }
    }

    func nextButtonTapped(){
        if !isLast{
            self.player.skipToNextItem()
        }
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
    }    
}
