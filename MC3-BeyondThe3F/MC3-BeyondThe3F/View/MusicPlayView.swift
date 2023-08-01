//
//  MusicPlayView.swift
//  MC3-BeyondThe3F
//
//  Created by 이연정 on 2023/07/25.
//


import SwiftUI
import MediaPlayer

struct MusicPlayView: View {
    
    @ObservedObject private var musicPlayer = MusicPlayer.shared
    @State private var progressRate: Double = 0.0
    @State var showCurrentPlayList: Bool = false
    @State var currentDegrees: Double = 0
    var body: some View {
        ZStack {
            NowPlayingView(currentDegrees: $currentDegrees)
            CurrentPlayListView()
                .opacity(showCurrentPlayList ? 1 : 0)
            
            ControlPanelView(
                progressRate: $progressRate,
                showCurrentPlayList: $showCurrentPlayList,
                currentDegrees: $currentDegrees
            )
        }
    }
}


struct NowPlayingView: View {
    
    @StateObject var musicPlayer = MusicPlayer.shared
    @Binding var currentDegrees: Double
    @State private var imageUrl:URL? = nil
    
    var foreverAnimation = Animation.linear(duration: 10.0).repeatForever(autoreverses: false)
    var stopAnimationLinear = Animation.linear(duration: 10.0)
    
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

                    if let url = imageUrl {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 320, height: 320)
                                .cornerRadius(451)
                                .clipped()
                                .rotationEffect(Angle(degrees: currentDegrees))
                        } placeholder: {
                            Image("musicPlayImageEmpty")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 320, height: 320)
                                .cornerRadius(451)
                                .clipped()
                                .rotationEffect(Angle(degrees: currentDegrees))
                        }
                    } else {
                        Image("musicPlayImageEmpty")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 320, height: 320)
                            .cornerRadius(451)
                            .clipped()
                    }
                }
                .offset(x: 64, y: 40)
                .task {
                    if let musicId = musicPlayer.currentMusicItem?.musicId{
                        imageUrl = await MusicItemDataModel.shared.getURL(musicId)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.custom(.secondaryDark))
        .onAppear {
            switch musicPlayer.playState {
            case .playing:
                startAnimation()
            case .paused:
                stopAnimation()
            default: break
            }
        }
//        .onChange(of: musicPlayer.isPlaying) { playState in
//            if playState {
//                startAnimation()
//            } else {
//                stopAnimation()
//            }
//        }
    }
    
    func startAnimation(){
        withAnimation(foreverAnimation) {
            currentDegrees = 360
        }
    }
    func stopAnimation(){
        withAnimation(stopAnimationLinear) {
            currentDegrees = 0
        }
    }
}


struct CurrentPlayListView: View {

    let musicPlayer = MusicPlayer.shared
    @State private var imageUrl:URL? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer().frame(height: 16)
                
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
                    ForEach(0 ..< musicPlayer.playlist.count, id: \.self) { index in
                        Button {
                            musicPlayer.playMusicInPlaylist(musicPlayer.playlist[index].musicId ?? "")
                        } label: {
                            MusicListRowView(
                                imageName: musicPlayer.playlist[index].savedImage ?? "annotation0",
                                songName: musicPlayer.playlist[index].songName ?? "",
                                artistName: musicPlayer.playlist[index].artistName ?? "",
                                musicListRowType: .saved,
                                buttonEllipsisAction: {

                                }
                            )
                            
//                            HStack{
//                                AsyncImage(url: URL(string: musicPlayer.playlist[index].savedImage ?? "")) { image in
//                                    image
//                                        .resizable()
//                                        .frame(width: 60, height: 60)
//                                        .cornerRadius(8)
//                                } placeholder: {
//                                    Image("musicPlayImageEmpty")
//                                        .resizable()
//                                        .frame(width: 60, height: 60)
//                                        .cornerRadius(8)
//                                }
//                                Spacer().frame(width: 16)
//
//                                VStack(alignment: .leading) {
//                                    Text("\(musicPlayer.playlist[index].songName ?? "")")
//                                        .body1(color: .white)
//                                        .truncationMode(.tail)
//                                        .lineLimit(1)
//                                    Spacer()
//                                        .frame(height: 6)
//                                    Text("\(musicPlayer.playlist[index].artistName ?? "")")
//                                        .body2(color: .gray500)
//                                        .truncationMode(.tail)
//                                        .lineLimit(1)
//                                }
//                                .frame(maxWidth: .infinity, alignment: .leading)
//
//                                Spacer()
//
//                                Button {
//
//                                } label: {
//                                    SFImageComponentView(symbolName: .ellipsis, color: .white)
//                                        .rotationEffect(.degrees(90.0))
//                                }
//                            }
//                            .frame(maxWidth: 390)
//                            .frame(height: 88)
//                            .padding(.horizontal, 20)
//                            .background(Color.custom(musicPlayer.playlist[index] == musicPlayer.currentMusicItem ? .secondaryDark : .background))
//                            .task {
//                                if let musicId = musicPlayer.currentMusicItem?.musicId{
//                                    imageUrl = await MusicItemDataModel.shared.getURL(musicId)
//                                }
//                            }
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
    
    @ObservedObject private var musicPlayer = MusicPlayer.shared
    @Binding var progressRate: Double
    @Binding var showCurrentPlayList: Bool
    @Binding var currentDegrees: Double

    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        if let currentMusicItem = musicPlayer.currentMusicItem {
                            Text("\(currentMusicItem.songName ?? "")")
                                .headline(color: .white)
                                .truncationMode(.tail)
                                .lineLimit(1)
                            
                            Spacer().frame(height: 8)
                            
                            Text("\(currentMusicItem.artistName ?? "")")
                                .body1(color: .gray300)
                                .truncationMode(.tail)
                                .lineLimit(1)
                        } else {
                            Text("재생 중이 아님")
                                .headline(color: .white)
                                .truncationMode(.tail)
                                .lineLimit(1)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.easeIn(duration: 0.3)) {
                            self.showCurrentPlayList.toggle()
                        }
                    } label: {
                        SFImageComponentView(symbolName: .list, color: .white, width: 28, height: 28)
                    }
                }
                Spacer().frame(height: 32)
                
                ControlButtonsView(
                    progressRate: $progressRate,
                    currentDegrees: $currentDegrees
                )
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
    @State private var currentDuration: Double = 0.0
    @State private var totalDuration: Double = (MusicPlayer.shared.player.nowPlayingItem?.playbackDuration ?? 0.0)
    @State private var isDragging = false
    @Binding var currentDegrees: Double
    var foreverAnimation = Animation.linear(duration: 10.0).repeatForever(autoreverses: false)
    var stopAnimationLinear = Animation.linear(duration: 10.0)
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

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
            
            Spacer().frame(height: 32)
            
            HStack {
                Button {
                    musicPlayer.previousButtonTapped()
                } label: {
                    SFImageComponentView(symbolName: .backward, color: .white, width: 45, height: 45)
                }

                Spacer().frame(width: 48)
                
                Button {
                    musicPlayer.playButtonTapped()
                } label: {
                    SFImageComponentView(symbolName: musicPlayer.playState == .paused ? .pause : .play, color: .white, width: 45, height: 45)
                }
                
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
        .onChange(of: musicPlayer.isPlaying) { playState in
            if playState {
                startAnimation()
            } else {
                stopAnimation()
            }
        }
        .onChange(of: currentDegrees) { state in
            print(state)
        }
    }
    
    func startAnimation(){
        withAnimation(foreverAnimation) {
            currentDegrees = 360
        }
    }
    func stopAnimation(){
        withAnimation(stopAnimationLinear) {
            currentDegrees = 0
        }
    }
}
