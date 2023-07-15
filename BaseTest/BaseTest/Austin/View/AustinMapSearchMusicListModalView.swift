//
//  AustinMapSearchMusicListModalView.swift
//  BaseTest
//
//  Created by Seungui Moon on 2023/07/13.
//

import SwiftUI
import MediaPlayer

struct MusicDummyItem: Hashable {
    var songName: String
    var coverImageName: String
    var artistName: String
    var musicId: String?
}

struct AustinMapSearchMusicListModalView: View {
    @Binding var musicList: [MusicDummyItem]
    private let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    var body: some View {
        ScrollView {
            VStack {
                ForEach(musicList, id: \.self) { item in
                    HStack{
                        Image("\(item.coverImageName)")
                        Spacer()
                            .frame(width: 20)
                        VStack(alignment: .leading) {
                            Text("\(item.songName)")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                            Spacer()
                                .frame(height: 10)
                            Text("\(item.artistName)")
                        }
                        Spacer()
                        Image(systemName: "play.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                if item.musicId != "" {
                                    musicPlayer.setQueue(with: [item.musicId!])
                                    Task {
                                        self.musicPlayer.prepareToPlay {error in
                                            if let error = error {
                                                print(error)
                                            } else {
                                                self.musicPlayer.play()
                                            }
                                       }
                                    }
                                }
                            }
                    }
                }
            }
            .padding()
        }
    }
}

//struct AustinMapSearchMusicListModalView_Previews: PreviewProvider {
//    static var previews: some View {
//        AustinMapSearchMusicListModalView()
//    }
//}
