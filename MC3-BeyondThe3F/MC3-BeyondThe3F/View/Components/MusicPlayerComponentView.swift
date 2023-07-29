//
//  MusicPlayerComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/20.
//

import SwiftUI
import MusicKit

struct MusicPlayerComponentView: View {
    
    @ObservedObject private var musicPlayer = MusicPlayer.shared
    @State private var isPlaying = false
    @State private var showMusicPlayListView = false
    
    
    var body: some View {
        HStack {
            Image("musicPlayImageEmpty")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            Spacer()
                .frame(width: 16)
            
            VStack(alignment: .leading) {
                if let currentMusicItem = musicPlayer.currentMusicItem {
                    Text("\(currentMusicItem.songName ?? "")")
                        .body1(color: .white)
                        .truncationMode(.tail)
                    Spacer()
                        .frame(height: 6)
                    Text("\(currentMusicItem.artistName ?? "")")
                        .body2(color: .gray500)
                        .truncationMode(.tail)
                } else {
                    Text("재생 중이 아님")
                        .body1(color: .white)
                        .truncationMode(.tail)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 48)
            
            Spacer()
                .frame(width: 16)
            
            HStack(spacing: 24) {
                Button {
                    musicPlayer.playButtonTapped()
                    isPlaying.toggle()
                } label: {
                    SFImageComponentView(symbolName: isPlaying ? .play : .pause, color: .white, width: 20)
                }
                
                Button {
                    musicPlayer.nextButtonTapped()
                } label: {
                    SFImageComponentView(symbolName: .forward, color: .white, width: 32)
                }
                .disabled(musicPlayer.isLast)
                
                Button {
                    showMusicPlayListView = true
                } label: {
                    SFImageComponentView(symbolName: .list, color: .white)
                }
            }
        }
        .padding(.horizontal, 20)
        .foregroundColor(.white)
        .frame(width: 390, height: 88)
        .background(Color.custom(.secondaryDark))
        .sheet(isPresented: $showMusicPlayListView) {
            MusicPlayView()
                .presentationDragIndicator(.visible)
        }
    }
}

//struct MusicPlayerComponentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MusicPlayerComponentView()
//    }
//}
