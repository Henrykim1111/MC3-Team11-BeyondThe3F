//
//  MusicPlayView.swift
//  MC3-BeyondThe3F
//
//  Created by 이연정 on 2023/07/25.
//


import SwiftUI

struct MusicPlayView: View {
    @State private var progressRate: Double = 0.0
    @State private var showCurrentPlayList: Bool = true
    
    @ObservedObject private var musicPlayer = MusicPlayer.shared
    
    var body: some View {
        ZStack {
            NowPlayingView()
            CurrentPlayListView()
                .opacity(showCurrentPlayList ? 0 : 1)
            
            ControlPanelView(progressRate: $progressRate, showCurrentPlayList: $showCurrentPlayList)
        }
    }
}


struct NowPlayingView: View {
    
    let musicPlayer = MusicPlayer.shared
    
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
                    
                    Image(musicPlayer.currentMusicItem?.savedImage ?? "musicPlayImageEmpty")     // 음악 ID 값에 따른 artworkImage 업데이트
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


struct CurrentPlayListView: View {

    let musicPlayer = MusicPlayer.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 16)
                
                HStack {
                    Text("현재 재생 목록")
                        .headline(color: .white)
                    Spacer()
                }
                .padding()
                
                if musicPlayer.playlist.isEmpty {
                    Text("현재 재생 목록이 없습니다.")
                        .padding()
                } else {
                    ForEach(musicPlayer.playlist) { musicItem in
                        MusicListRowView(
                            imageName: (musicItem.savedImage != nil) ? musicItem.savedImage! :  "annotation0",
                            songName: musicItem.songName ?? "",
                            artistName: musicItem.artistName ?? "",
                            musicListRowType: .saved,
                            buttonEllipsisAction: {
                                
                            }
                        )
                        .padding(.horizontal, 20)
                        .background(Color.custom(musicItem == musicPlayer.currentMusicItem ? .secondaryDark : .background))
                    }
                }
            }
            Spacer()
                .frame(height: 276)
        }
        .frame(width: 390)
        .background(Color.custom(.background))
    }
}


struct ControlPanelView: View {
    @Binding var progressRate: Double
    @Binding var showCurrentPlayList: Bool
    
    @ObservedObject private var musicPlayer = MusicPlayer.shared

    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                HStack {
                    VStack(alignment:.leading) {
                        Text("\(musicPlayer.currentMusicItem?.songName ?? "")")
                            .headline(color: .white)
                        Spacer().frame(height: 8)
                        Text("\(musicPlayer.currentMusicItem?.artistName ?? "")")
                            .body1(color: .gray300)
                    }
                    Spacer()
                    
                    Button {
                        withAnimation(.easeIn(duration: 0.3)) {
                            self.showCurrentPlayList.toggle()
                        }
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
    
    let musicPlayer = MusicPlayer.shared
    @Binding var progressRate: Double
    
    @State private var currentTime = MusicPlayer.shared.player.currentPlaybackTime
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    @State private var currentDuration: Double = 0.0
    @State private var totalDuration: Double = (MusicPlayer.shared.player.nowPlayingItem?.playbackDuration ?? 0.0)
    @State private var isDragging = false

    
    func sliderChanged(editingStarted: Bool) {
      if editingStarted {
          self.musicPlayer.player.pause()
          isDragging = true
      } else {
          self.musicPlayer.player.currentPlaybackTime = currentTime
          self.musicPlayer.player.play()
          isDragging = false

      }
    }
    var body: some View {
        VStack {
            HStack {
                // 재생한 시간
                Text("\(currentTime.timeToString)")
                    .frame(width: 45, alignment: .leading)
                    .caption(color: .white)
                    .onReceive(timer) { _ in
                        guard !isDragging else { return }
                        currentTime = MusicPlayer.shared.player.currentPlaybackTime
                        
                        totalDuration = (MusicPlayer.shared.player.nowPlayingItem?.playbackDuration ?? 0.0)
                    }
                Slider(value: $currentTime, in: 0...totalDuration, onEditingChanged: sliderChanged)
                // 남은 시간
                Text("-\(((musicPlayer.player.nowPlayingItem?.playbackDuration ?? 0.0) - MusicPlayer.shared.player.currentPlaybackTime).timeToString)")
                    .frame(width: 50, alignment: .trailing)
                    .caption(color: .white)
            }
            
            Spacer().frame(height: 36)
            
            HStack {
                Button {
                    musicPlayer.previousButtonTapped()
                    musicPlayer.playlist = MainDataModel.shared.getData[0].musicList
                } label: {
                    SFImageComponentView(symbolName: .backward, color: .white, width: 45, height: 45)
                }

                Spacer().frame(width: 48)
                
                PlayPauseButton()
                
                Spacer().frame(width: 48)
                
                Button {
                    musicPlayer.nextButtonTapped()
                } label: {
                    SFImageComponentView(symbolName: .forward, color: .white, width: 45, height: 45)
                }
                .disabled(musicPlayer.isLast)
            }
            Spacer()
        }
    }
}


struct PlayPauseButton: View {
    
    let musicPlayer = MusicPlayer.shared
    
    var body: some View {
        Button {
            musicPlayer.playButtonTapped()
        } label: {
            Image(systemName: "play.fill")
                .resizable()
                .scaledToFit()
                .frame(width: CGFloat(45), height: CGFloat(45))
                .foregroundColor(Color.custom(.white))
        }
    }
}
