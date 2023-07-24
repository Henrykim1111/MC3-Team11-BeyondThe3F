//
//  MusicCell.swift
//  BaseTest
//
//  Created by 이연정 on 2023/07/20.
//

import SwiftUI
import MusicKit

// 음악 앨범을 검색하고 표시하는 뷰
// 사용자가 검색어를 입력하면 해당 검색어로 음악 앨범을 찾아 표시
// 사용자가 검색어를 비워두면 검색 결과가 리셋

struct MusicView: View {
    @State private var searchTerm = ""
    // 사용자의 검색어를 저장하는 상태 변수
    @State private var albums: MusicItemCollection<Album> = []
    // 검색 결과로 나타낼 앨범들을 저장하는 상태 변수
    // 'MusicItemCollection'은 MusicKit에서 제공하는 앨범 등 음악 항목들의 컬렉션을 나타냄
    
    var body: some View {
        rootView
            .onChange(of: searchTerm, perform: requestUpdatedSearchResults)
            .musicAuthViewSheet()
            
    }
    
    private var rootView: some View {
        NavigationView {
            navigationViewContents
                .navigationTitle("Music Albums")
        }
        .searchable(text: $searchTerm, prompt: "Albums")
        // SwiftUI의 검색 가능한 뷰로, 사용자가 검색어를 입력할 수 있는 기능을 제공
    }
    
    private var navigationViewContents: some View {
        VStack {
            searchResultsList
                .animation(.default, value: albums)
        }
    }
    
    private var searchResultsList: some View {
        List {
            ForEach(albums, id: \.self) { album in
                AlbumCell(album)
                // 각 앨범을 표시하는 데 사용되는 셀 뷰
            }
        }
    }
    
    private func requestUpdatedSearchResults(for searchTerm: String) {
    // 검색어가 업데이트되면 해당 검색어로 MusicKit을 사용하여 앨범을 검색하고 결과를 'apply'메서드를 통해 UI에 업데이트
        Task {
            if searchTerm.isEmpty {
                await self.reset()
            } else {
                do {
                    var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Album.self])
                    searchRequest.limit = 5
                    let searchResponse = try await searchRequest.response()
                    
                    await self.apply(searchResponse, for: searchTerm)
                    // apply(_:for:)는 검색 결과를 UI에 적용하는 메서드로, 이 메서드는 검색어가 변경된 후에만 앨범 결과를 UI에 반영
                } catch {
                    print("Search request failed with error: \(error).")
                    await self.reset()
                    // reset() 검색어가 비워질 때 결과를 초기화하는 메서드
                }
            }
        }
    }
    
    @MainActor
    private func apply(_ searchResponse: MusicCatalogSearchResponse, for searchTerm: String) {
        if self.searchTerm == searchTerm {
            self.albums = searchResponse.albums
        }
    }
    
    @MainActor
    private func reset() {
        self.albums = []
    }
}
struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView()
    }
}
