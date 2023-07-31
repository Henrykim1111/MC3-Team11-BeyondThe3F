//
//  WTMusicSearchView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/29.
//

import MusicKit
import SwiftUI

struct WTMusicSearchView: View {
    @AppStorage("isFirst") private var isFirst = false
    @State private var searchTerm = ""
    @State private var showSearchView = true
    @StateObject private var musicSearchViewModel = MusicSearchViewModel()
    @StateObject private var musicItemUpdateViewModel = MusicItemUpdateViewModel.shared
    let musicItemDataModel = MusicItemDataModel.shared
    let musicPlayer = MusicPlayer.shared
    var persistentContainer = PersistenceController.shared.container
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                Text("안녕하세요!\n요즘 가장 많이 듣는 노래를 알려주세요.")
                    .lineSpacing(7)
                    .headline(color: .white)
                Spacer()
                    .frame(height: 16)
                Text("음악명으로 검색해주세요.")
                    .body2(color: .gray400)
                    .multilineTextAlignment(.leading)
                Spacer()
                    .frame(height: 32)
                MusicSearchComponentView(searchTerm: $searchTerm, showSearchView: $showSearchView)
                switch musicSearchViewModel.musicSearchState {
                case .notSearched:
                    Spacer()
                        .frame(height: 16)
                case .searching:
                    HStack {
                        Spacer()
                        ProgressView("음악 검색 중")
                            .foregroundColor(Color.custom(.gray400))
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.custom(.gray400)))
                        Spacer()
                    }
                case .notFound:
                    HStack {
                        Spacer()
                        Text("해당하는 노래를 찾지 못했습니다")
                            .body2(color: .gray400)
                        Spacer()
                    }
                case .success:
                    MusicSearchResultsList
                }
                Spacer()
                
            }
            .background(Color.custom(.background))
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.custom(.background))
        .onChange(of: searchTerm, perform: musicSearchViewModel.requestUpdateSearchResults)
        .onAppear {
            requestMusicAutthorization()
        }
    }
    private func requestMusicAutthorization(){
        Task {
            let authorizationStatus = await MusicAuthorization.request()
            
        }
    }
}



struct WTMusicSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WTMusicSearchView()
    }
}


extension WTMusicSearchView {
    
    private var ResentlySearchList: some View {
        ScrollView {
            LazyVStack {
                ForEach(0 ..< musicSearchViewModel.resentlySearchList.count, id: \.self) { index in
                    HStack {
                        Text(musicSearchViewModel.resentlySearchList[index].songName ?? "")
                            .body1(color: .white)
                        Spacer()
                        Text("\(Date.formatToString(searchDate: musicSearchViewModel.resentlySearchList[index].date ?? Date()))")
                            .body2(color: .gray400)
                        Spacer()
                            .frame(width: 24)
                        SFImageComponentView(
                            symbolName: .cancel,
                            color: .white,
                            width: 16,
                            height: 16
                        )
                        .onTapGesture {
                            musicSearchViewModel.removeMusicHistoryById(musicId: musicSearchViewModel.resentlySearchList[index].musicId ?? "")
                        }
                    }
                    .frame(maxWidth: 390)
                    .frame(height: 56)
                    .onTapGesture {
                        // TODO: add music to music player
                    }
                }
            }
        }
    }
    
    private var MusicSearchResultsList: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    Spacer()
                }
                ForEach(musicSearchViewModel.searchSongs, id: \.self) { item in
                    Button {
                        let newItem = MusicItem(context: persistentContainer.viewContext)
                        
                        newItem.musicId = item.id.rawValue
                        newItem.latitude = 0
                        newItem.longitude = 0
                        newItem.locationInfo = ""
                        newItem.savedImage = ""
                        newItem.generatedDate = Date()
                        newItem.songName = item.title
                        newItem.artistName = item.artistName
                        
                        musicPlayer.playlist.append(newItem)
                        musicSearchViewModel.addMusicHistory(musicId: item.id.rawValue, songName: item.title)
                    } label: {
                        HStack {
                            if let existingArtwork = item.artwork {
                                ArtworkImage(existingArtwork, width: 60)
                                    .cornerRadius(8)
                            }
                            Spacer()
                                .frame(width: 16)
                            VStack(alignment: .leading){
                                Text(item.title)
                                    .body1(color: .white)
                                    .padding(.bottom, 4)
                                Text(item.artistName)
                                    .body2(color: .gray500)
                            }
                            Spacer()
                            NavigationLink {
                                EditMapPositionView(nextProcess: .forward)
                                    .navigationBarBackButtonHidden(true)
                                    .simultaneousGesture(TapGesture().onEnded {
                                        Task {
                                            musicItemUpdateViewModel.resetInitialMusicItem()
                                            guard let musicItems = await musicItemDataModel.getInfoByMusicId(item.id.rawValue) else {
                                                return
                                            }
                                            guard let musicItem = musicItems.items.first else {
                                                return
                                            }
                                            musicItemUpdateViewModel.musicItemshared.musicId = musicItem.id.rawValue
                                            musicItemUpdateViewModel.musicItemshared.songName = musicItem.title
                                            musicItemUpdateViewModel.musicItemshared.artistName = musicItem.artistName
                                            if let imageURL = musicItem.artwork?.url(width: 500, height: 500) {
                                                musicItemUpdateViewModel.musicItemshared.savedImage = "\(imageURL)"
                                            } else {
                                                musicItemUpdateViewModel.musicItemshared.savedImage = nil
                                            }
                                        }
                                        
                                    })
                                
                            } label: {
                                SFImageComponentView(symbolName: .plus, color: .white, width: 22, height: 22)
                            }
                            
                        }
                    }
                }
            }
        }
    }
}
