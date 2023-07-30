//
//  MusicPlayView.swift
//  MC3-BeyondThe3F
//
//  Created by 이연정 on 2023/07/25.
//


import SwiftUI
import MediaPlayer

struct MusicPlayView: View {
    @State private var progressRate: Double = 0.0
    @State private var showCurrentPlayList: Bool = false
    
    @ObservedObject private var musicPlayer = MusicPlayer.shared
    
    var body: some View {
        ZStack {
            NowPlayingView()
            CurrentPlayListView()
                .opacity(showCurrentPlayList ? 1 : 0)
            
            ControlPanelView(progressRate: $progressRate, showCurrentPlayList: $showCurrentPlayList)
        }
    }
}


struct NowPlayingView: View {
    
    let musicPlayer = MusicPlayer.shared
    @State private var isRotating = false
    
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
                    
                    if let url = URL(string: musicPlayer.currentMusicItem?.savedImage ?? "") {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 320, height: 320)
                                .cornerRadius(451)
                                .clipped()
                                .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
                                .animation(Animation.linear(duration: 10).repeatForever(autoreverses: false), value: isRotating)
                        } placeholder: {
                            Image("musicPlayImageEmpty")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 320, height: 320)
                                .cornerRadius(451)
                                .clipped()
                                .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
                                .animation(Animation.linear(duration: 10).repeatForever(autoreverses: false), value: isRotating)
                        }
                    } else {
                        Image("musicPlayImageEmpty")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 320, height: 320)
                            .cornerRadius(451)
                            .clipped()
                            .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
                            .animation(Animation.linear(duration: 10).repeatForever(autoreverses: false), value: isRotating)
                    }
                }
                .offset(x: 64, y: 40)
            }
            Spacer()
        }
        .padding()
        .background(Color.custom(.secondaryDark))
        .onReceive(NotificationCenter.default.publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange)) { _ in
            if musicPlayer.player.playbackState == .playing {
                isRotating = true
            } else {
                isRotating = false
            }
        }
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
                        .body1(color: .gray500)
                        .padding()
                } else {
                    ForEach(musicPlayer.playlist) { musicItem in
                        Button {
//                            musicPlayer.playSong(musicItem)     // 탭하면 해당 노래를 재생
                        } label: {
                            HStack{
                                Image("musicPlayImageEmpty")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                Spacer()
                                    .frame(width: 16)
                                VStack(alignment: .leading){
                                    Text("\(musicItem.songName ?? "")")
                                        .body1(color: .white)
                                        .padding(.bottom, 4)
                                    Text("\(musicItem.artistName ?? "")")
                                        .body2(color: .gray500)
                                }
                                Spacer()
                                Button {
                                    
                                } label: {
                                    SFImageComponentView(symbolName: .ellipsis, color: .white)
                                        .rotationEffect(.degrees(90.0))
                                }
                            }
                            .frame(maxWidth: 390)
                            .frame(height: 88)
                            .padding(.horizontal, 20)
                            .background(Color.custom(musicItem == musicPlayer.currentMusicItem ? .secondaryDark : .background))
                        }
                    }
                }
            }
            Spacer()
                .frame(height: 276)
        }
        .frame(maxWidth: 390)
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
                        if let currentMusicItem = musicPlayer.currentMusicItem {
                            Text("\(currentMusicItem.songName ?? "")")
                                .headline(color: .white)
                            Spacer()
                                .frame(height: 8)
                            Text("\(currentMusicItem.artistName ?? "")")
                                .body1(color: .gray300)
                        } else {
                            Text("재생 중이 아님")
                                .headline(color: .white)
                        }
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
    
    @ObservedObject private var musicPlayer = MusicPlayer.shared
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
                    .accentColor(Color.custom(.white))
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
                
//                Button {
//                    musicPlayer.playButtonTapped()
//                } label: {
//                    SFImageComponentView(symbolName: musicPlayer.isPlaying ? .play : .pause, color: .white, width: 45)
//                }
                
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
