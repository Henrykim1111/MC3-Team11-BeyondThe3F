//
//  MusicSearchView.swift
//  MC3-BeyondThe3F
//
//  Created by 이연정 on 2023/07/24.
//

import SwiftUI
import MusicKit

struct SearchItem: Identifiable {
    let id = UUID()
    var searchText: String
    var stringDate: String
    var searchDate: Date
}


struct MusicSearchView: View {
    
    @State var resentlySearchList : [SearchItem] = [
        SearchItem(searchText: "hello", stringDate: Date.formatToString(searchDate: Date()), searchDate: Date()),
        SearchItem(searchText: "love", stringDate: Date.formatToString(searchDate: Date()), searchDate: Date())
    ]
    @Binding var searchTerm: String
    @State private var searchSongs: MusicItemCollection<Song> = []
    private let historymodel = HistoryDataModel.shared
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 24)
                
                if searchTerm == "" {
                    resentlySearchTitle
                    Spacer()
                        .frame(height: 16)
                    if resentlySearchList.isEmpty {
                        Spacer()
                            .frame(height: 16)
                        Text("최근 검색어 내역이 없습니다.")
                            .body2(color: .gray200)
                    } else {
                        ResentlySearchList
                    }
                    Spacer()
                } else {
                    ScrollView {
                        MusicSearchResultsList
                    }
                }
            }
            .padding()
            .background(Color.custom(.background))
            .onChange(of: searchTerm, perform: requestUpdateSearchResults)
        }
    }

    
    private func requestUpdateSearchResults(for searchTerm: String) {
        Task {
            if searchTerm.isEmpty {
                await self.reset()
            } else {
                do {
                    var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
                    searchRequest.limit = 10
                    let searchResponse = try await searchRequest.response()
                    await self.apply(searchResponse, for: searchTerm)
                } catch {
                    print("search request failed")
                    await self.reset()
                }
            }
        }
    }
    private func playMusic(musicId: String){
        // TODO: musicListRow를 클릭한 경우 해당 음악이 playMusic에 추가되는 기능 구현 필요
    }
    
    private func addMusicToData(music: Song){
        // TODO: 해당 musicListRow의 + 버튼을 누른 경우 musicVO에 추가되는 기능 구현 필요
    }
    
    private func searchHistoryTerm(historyTerm: String){
        self.searchTerm = historyTerm
        self.resentlySearchList.append(
            SearchItem(
                searchText: historyTerm,
                stringDate: Date.formatToString(searchDate: Date()),
                searchDate: Date()
            )
        )
    }
    
    @MainActor
    private func apply(_ searchResponse: MusicCatalogSearchResponse, for searchTerm: String) {
        if self.searchTerm == searchTerm {
            self.searchSongs = searchResponse.songs
        }
    }
    
    
    @MainActor
    private func reset() {
        self.searchSongs = []
    }
}



struct MusicSearchPreview: View {
    @State var searchTerm: String = ""
    var body: some View {
        VStack {
            TextField("음악을 검색하세요", text: $searchTerm)
            MusicSearchView(searchTerm: $searchTerm)
        }
    }
}


struct MusicSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MusicSearchPreview()
    }
}

extension MusicSearchView {
    
    private var resentlySearchTitle: some View {
        HStack {
            Text("최근 검색 목록")
                .headline(color: .white)
            Spacer()
            Button {
                resentlySearchList.removeAll()
            } label: {
                Text("모두 지우기")
                    .body2(color: .primary)
            }
        }
    }
    
    private var ResentlySearchList: some View {
        VStack {
            if resentlySearchList.isEmpty {
                Text("검색 기록이 없습니다")
            } else {
                ForEach(0 ..< resentlySearchList.count, id: \.self) { index in
                    HStack {
                        Text(resentlySearchList[index].searchText)
                            .body1(color: .white)
                        Spacer()
                        Text(resentlySearchList[index].stringDate)
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
                            resentlySearchList.remove(at: index)
                        }
                    }
                    .frame(maxWidth: 390)
                    .frame(height: 56)
                    .onTapGesture {
                        searchHistoryTerm(historyTerm: resentlySearchList[index].searchText)
                    }
                }
            }
        }
    }

    private var MusicSearchResultsList: some View {
        VStack {
            Spacer()
                .frame(width: 390)
            if searchSongs.isEmpty {
                Text("해당하는 노래를 찾지 못했습니다")
                    .body2(color: .white)
            } else {
                ForEach(searchSongs, id: \.self) { item in
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
                            // TODO: 음악 추가하는 페이지로 이동
                        } label: {
                            SFImageComponentView(symbolName: .ellipsis, color: .white)
                                .rotationEffect(.degrees(90.0))
                        }
                    }
                }
            }
        }
    }
    
}
