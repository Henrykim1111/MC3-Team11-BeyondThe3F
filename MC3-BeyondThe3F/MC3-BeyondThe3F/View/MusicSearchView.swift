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
    var searchDate: String
}

struct MusicSearchView: View {
    
    @State var resentlySearchList : [SearchItem] = [
        SearchItem(searchText: "hello", searchDate: "07.23"),
        SearchItem(searchText: "love", searchDate: "07.23")
    ]
    
    @State private var searchTerm = ""
    @State private var searchSongs: MusicItemCollection<Song> = []
    
    var body: some View {
        NavigationStack {
            VStack {
                MusicSearchComponentView(textInput: $searchTerm)    // MusicSearchCompoinentView UI 수정 필요
                
                Spacer()
                    .frame(height: 24)
                
                if searchTerm == "" {
                    
                    VStack {
                        HStack {
                            Text("최근 검색 목록")
                                .headline(color: .white)
                            Spacer()
                            Button {    // 최근 검색 목록 리스트 모두 삭제
                                resentlySearchList.removeAll()
                            } label: {
                                Text("모두 지우기")
                                    .body2(color: .primary)
                            }
                        }
                        Spacer()
                            .frame(height: 16)
                        resentlySearchListLow
                    }
                    Spacer()
                    
                } else {
    
                    ScrollView {
                        VStack {
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
                                        Text(item.id.rawValue)
                                            .body2(color: .gray500)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            .background(Color.custom(.background))
        }
        .padding()
        .background(Color.custom(.background))
        .onChange(of: searchTerm, perform: requestUpdateSearchResults)
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




struct MusicSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MusicSearchView()
    }
}




extension MusicSearchView {
    
    private var resentlySearchListLow: some View {
        ForEach(0 ..< resentlySearchList.count, id: \.self) { index in
            HStack {
                Text(resentlySearchList[index].searchText)
                    .body1(color: .white)
                Spacer()
                Text(resentlySearchList[index].searchDate)
                    .body2(color: .gray400)
                Spacer()
                    .frame(width: 24)
                SFImageComponentView(symbolName: .cancel, color: .white)
                    .onTapGesture {
                        resentlySearchList.remove(at: index)
                    }
            }
            .frame(maxWidth: 390)
            .frame(height: 56)
        }
    }
}







//    func remakedDate() -> String {
//        let dateString = card.createdDate
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yy-MM-dd"
//        guard let date = formatter.date(from: dateString) else {
//            return ""
//        }
//        formatter.dateFormat = "dd"
//        return formatter.string(from: date)
//    }
