//
//  MusicSearchView.swift
//  MC3-BeyondThe3F
//
//  Created by 이연정 on 2023/07/24.
//

import SwiftUI
import MusicKit


struct MusicSearchView: View {
    @StateObject private var musicSearchViewModel = MusicSearchViewModel()
    @State private var isPresentedDeleteAll = false
    @Binding var searchTerm: String
    @Binding var isUpdate: Bool
    let musicItemUpdateViewModel = MusicItemUpdateViewModel.shared
    let musicItemDataModel = MusicItemDataModel.shared
    let musicPlayer = MusicPlayer.shared
    var persistentContainer = PersistenceController.shared.container
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 24)
                switch musicSearchViewModel.musicSearchState {
                case .notSearched:
                    ResentlySearchTitle
                    Spacer()
                        .frame(height: 16)
                    if musicSearchViewModel.resentlySearchList.isEmpty {
                        Spacer()
                            .frame(height: 16)
                        Text("최근 검색어 내역이 없습니다.")
                            .body2(color: .gray400)
                    } else {
                        ResentlySearchList
                    }
                    Spacer()
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
                    ScrollView {
                        MusicSearchResultsList
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color.custom(.background))
            .onChange(of: searchTerm, perform: musicSearchViewModel.requestUpdateSearchResults)
        }
        .alert("정말로 검색 기록을 모두 지우시겠어요?", isPresented: $isPresentedDeleteAll) {
            Button("삭제", role: .destructive) {
                musicSearchViewModel.removeAllMusicHistory()
            }
            Button("취소", role: .cancel) {
                isPresentedDeleteAll = false
            }
        }
        

    }
}

extension MusicSearchView {
    private var ResentlySearchTitle: some View {
        HStack {
            Text("최근 검색 목록")
                .headline(color: .white)
            Spacer()
            Button {
                if !musicSearchViewModel.resentlySearchList.isEmpty {
                    self.isPresentedDeleteAll = true
                }
            } label: {
                Text("모두 지우기")
                    .body2(color: .primary)
                    
            }
        }
    }
    
    private var ResentlySearchList: some View {
        VStack {
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

    private var MusicSearchResultsList: some View {
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
                        Button {
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
                            self.isUpdate = true
                        } label: {
                            SFImageComponentView(symbolName: .plus, color: .white, width: 22, height: 22)
                        }
                    }
                }
            }
        }
    }
}


struct MusicSearchPreview: View {
    @State var searchTerm: String = ""
    @State var showAddMusicView = false
    var body: some View {
        VStack {
            TextField("음악을 검색하세요", text: $searchTerm)
            MusicSearchView(
                searchTerm: $searchTerm,
                isUpdate: $showAddMusicView
            )
        }
    }
}


struct MusicSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MusicSearchPreview()
    }
}
