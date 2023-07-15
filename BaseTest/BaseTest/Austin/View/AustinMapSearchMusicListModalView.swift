//
//  AustinMapSearchMusicListModalView.swift
//  BaseTest
//
//  Created by Seungui Moon on 2023/07/13.
//

import SwiftUI

struct MusicDummyItem: Hashable {
    var songName: String
    var coverImageName: String
    var artistName: String
}

struct AustinMapSearchMusicListModalView: View {
    @Binding var musicList: [MusicDummyItem]
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
