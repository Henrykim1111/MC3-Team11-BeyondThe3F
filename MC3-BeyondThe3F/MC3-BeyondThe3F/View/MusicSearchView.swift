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
    
    var resentlySearchList : [SearchItem] = [
        SearchItem(searchText: "hello", searchDate: "2023-07-23 15:47:15 +0000"),
        SearchItem(searchText: "love", searchDate: "2023-07-23 15:47:15 +0000")
    ]
    
    func remakeDate() -> String {
        let dateString = self.searchDate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        guard let date = formatter.date(from: dateString) else {
            return ""
        }
        formatter.dateFormat = "MM.dd"
        return formatter.string(from: date)
    }
}




struct MusicSearchView: View {
    
    @Binding var resentlySearchList : [SearchItem]
    @State private var searchTerm = ""
    @State private var searchSongs: MusicItemCollection<Song> = []
    
    var body: some View {
        ZStack {
            VStack {
                // MusicSearchComponentView(textInput: $searchTerm)
                // MusicSearchComponentView에서 @Binding var textInput: String로 수정 후 확인 가능
                Spacer()
                    .frame(height: 24)
                
                if searchTerm == "" {
                    if resentlySearchList.isEmpty {
                        Text("최근 검색어 내역이 없습니다.")
                            .body2(color: .gray200)
                        Spacer()
                    } else {
                        resentlySearchTitle
                        Spacer()
                            .frame(height: 16)
                        resentlySearchListLow
                        Spacer()
                    }
                } else {
                    ScrollView {
                        musicSearchResultsListLow
                    }
                }
            }
            .padding()
            .background(Color.custom(.background))
            .onChange(of: searchTerm, perform: requestUpdateSearchResults)
            
            VStack {
                Spacer()
                MusicPlayerComponentView()
            }
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




//struct MusicSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        MusicSearchView()
//    }
//}




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
    
    
    private var resentlySearchListLow: some View {
        VStack {
            ForEach(0 ..< resentlySearchList.count, id: \.self) { index in
                HStack {
                    Text(resentlySearchList[index].searchText)
                        .body1(color: .white)
                    Spacer()
                    Text(resentlySearchList[index].remakeDate())
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


    private var musicSearchResultsListLow: some View {
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
                        Text(item.artistName)
                            .body2(color: .gray500)
                    }
                    Spacer()
                    Button {
                        // 음악 추가하는 페이지로 이동
                    } label: {
                        SFImageComponentView(symbolName: .ellipsis, color: .white)
                            .rotationEffect(.degrees(90.0))
                    }
                }
            }
        }
    }
    
//    private var musicSearchResultsListLow: some View {
//        VStack {
//            ForEach(searchSongs, id: \.self) { item in
//                MusicListRowView(imageName: item.artwork ?? "annotation0",
//                                 songName: item.title,
//                                 artistName: item.id.rawValue,
//                                 musicListRowType: .saved)
//            }
//        }
//    }
    
}
