//
//  CitylistView.swift
//  BaseTest
//
//  Created by Hyungmin Kim on 2023/07/23.
//

import SwiftUI

struct MusicInfo {
    var title = ""
    var artist = ""
}

struct CitylistView: View {
    
    @State private var musiclists = [
        MusicInfo(title: "Big Wave", artist: "293 studio"),
        MusicInfo(title: "최애의 아이", artist: "YOASOBI"),
        MusicInfo(title: "Shape of you", artist: "Ed Sheeran")
    ]
    
    var body: some View {
        VStack(spacing: 0){
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .border(.gray)
                HStack {
                    VStack (alignment: .leading) {
                        Text("지곡동")
                            .font(.title)
                        Text("노래 12곡")
                    }
                    Spacer()
                    Image(systemName: "play.fill")
                }
                .padding()
            }
            .frame(width: 318, height: 94)
            List {
                ForEach(0..<musiclists.count, id: \.self) { index in
                    HStack {
                        Rectangle()
                            .frame(width: 60, height: 60)
                        VStack(alignment: .leading) {
                            Text("\(musiclists[index].title)")
                                .font(.title2)
                            Text("\(musiclists[index].artist)")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    
                }
            }
            .frame(width: 318)
            .border(.gray)
            .listStyle(.plain)
        }
    }
}

struct CitylistView_Previews: PreviewProvider {
    static var previews: some View {
        CitylistView()
    }
}
