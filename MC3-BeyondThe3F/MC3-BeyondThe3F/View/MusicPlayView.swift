//
//  MusicPlayView.swift
//  MC3-BeyondThe3F
//
//  Created by 이연정 on 2023/07/25.
//


import SwiftUI

struct MusicPlayView: View {
    @State private var progressRate: Double = 0.0
    @State private var isToggledView: Bool = true
    
    var body: some View {
        ZStack {
            if isToggledView {
                NowPlayingView()
            } else {
                CurrentPlayListView()
            }
            
            ControlPanelView(progressRate: $progressRate, isToggledView: $isToggledView)
        }
    }
}


struct NowPlayingView: View {
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 390, height: 390)
                    .blur(radius: 50)
                    .offset(x: -9, y: -22)
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 451, height: 451)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: -10, y: -10)
                    
                    Image("musicPlayImage")     // 음악 ID 값에 따른 artworkImage 업데이트
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 320, height: 320)
                        .cornerRadius(451)
                        .clipped()
                }
                .offset(x: 64, y: 40)
            }
            Spacer()
        }
        .padding()
        .background(Color.custom(.secondaryDark))
    }
}


struct ControlPanelView: View {
    @Binding var progressRate: Double
    @Binding var isToggledView: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                HStack {
                    VStack {
                        Text("Big Wave")    // 음악 ID 값에 따른 title 업데이트
                            .headline(color: .white)
                        Spacer().frame(height: 8)
                        Text("293 studio")      // 음악 ID 값에 따른 artistName 업데이트
                            .body1(color: .gray300)
                    }
                    Spacer()
                    
                    Button {
                        isToggledView.toggle()
                    } label: {
                        SFImageComponentView(symbolName: .list, color: .white, width: 28, height: 28)
                    }
                }
                
                Spacer().frame(height: 34)
                
                ControlButtonsView(progressRate: $progressRate)
            }
            .padding(.horizontal, 20)
            .padding(.top, 36)
            .frame(maxWidth: 390)
            .frame(height: 276)
            .background(Color.custom(.secondaryDark))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: -10)
        }
        .ignoresSafeArea()
    }
}


struct ControlButtonsView: View {
    @Binding var progressRate: Double
    
    var body: some View {
        VStack {
            HStack {
                // 재생한 시간
                Text("00:00")
                    .frame(width: 45, alignment: .leading)
                    .caption(color: .white)
                ProgressView(value: progressRate)
                // 남은 시간
                Text("- 00:00")
                    .frame(width: 50, alignment: .trailing)
                    .caption(color: .white)
            }
            
            Spacer().frame(height: 36)
            
            HStack {
                Button {
                    // Play Backward Button
                } label: {
                    SFImageComponentView(symbolName: .backward, color: .white, width: 55, height: 55)
                }

                Spacer().frame(width: 40)
                // Play/Pause Button
                PlayPauseButton()
                Spacer().frame(width: 40)
                Button {
                    // Play Forward Button
                } label: {
                    SFImageComponentView(symbolName: .forward, color: .white, width: 55, height: 55)
                    // 리스트의 마지막 노래일 경우 비활성화
                    // .disabled(isFinalList)
                    // @State private var isFinalList = true
                }
            }
            Spacer()
        }
    }
}


struct PlayPauseButton: View {
    var body: some View {
        Button {
//            playerViewModel.playbackState == .playing ? playerViewModel.player.pause() : playerViewModel.player.play()
        } label: {
//            (playerViewModel.playbackState == .playing ? Image(systemName: "pause.fill") : Image(systemName: "play.fill"))
            Image(systemName: "play.fill")
                .resizable()
                .scaledToFit()
                .frame(width: CGFloat(55), height: CGFloat(55))
                .foregroundColor(Color.custom(.white))
        }
    }
}


struct CurrentPlayListView: View {
    @State var playListItem : [MusicItemVO] = [
        MusicItemVO(musicId: "1004836383", latitude: 43.70564024126748,longitude: 142.37968945214223,playedCount: 0, songName: "BIG WAVE",artistName: "artist0",  generatedDate: Date(), savedImage: "annotationTest"),
        MusicItemVO(musicId: "1004836383", latitude: 43.81257464206404,longitude: 142.82112322464369,playedCount: 0, songName: "BIG WAVE",artistName: "artist0",  generatedDate: Date(), savedImage: "annotaion1"),
        MusicItemVO(musicId: "1004836383", latitude: 43.38416585162576,longitude: 141.7252598737476,playedCount: 0, songName: "BIG WAVE",artistName: "artist0",  generatedDate: Date(), savedImage: "annotaion2"),
        MusicItemVO(musicId: "1004836383", latitude: 45.29168643283501,longitude: 141.95286751470724,playedCount: 0, songName: "BIG WAVE",artistName: "artist0",  generatedDate: Date(), savedImage: "annotaion3")
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("재생 대기")
                        .headline(color: .white)
                    Spacer()
                }
                
                ForEach(playListItem) { musicItem in
                    MusicListRowView(
                        imageName: (musicItem.savedImage != nil) ? musicItem.savedImage! :  "annotation0",
                        songName: musicItem.songName,
                        artistName: musicItem.artistName,
                        musicListRowType: .saved,
                        buttonEllipsisAction: {
                            
                        }
                    )
                    
                    // 현재 재생되고 있는 노래라면 백그라운드 컬러 다르게 처리
                }
                
                
            }
            
            Spacer()
                .frame(height: 276)
        }
        .padding()
        .background(Color.custom(.background))
        
    }
}
