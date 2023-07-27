//
//  MusicSearchView.swift
//  BaseTest
//
//  Created by 이연정 on 2023/07/20.
//

import SwiftUI
import MusicKit

struct MusicSearchView: View {
    
    @State private var searchTerm = ""
    // 사용자의 검색어를 추적하는 State 변수
    @State private var songs: MusicItemCollection<Song> = []
    // 검색 결과로 받은 노래들을 저장하는 State 변수
    // 'MusicItemCollection'은 MusicKit의 일부 클래스로, 음악 항목들을 컬렉션으로 다루기 위해 사용
    // 여기에서는 'Song'타입의 노래들을 저장
    
    var body: some View {
        NavigationStack {
            VStack {
//                Spacer()
//                    .frame(height: 30)
//                SearchComponentView(textInput: $searchTerm)
//                if searchTem == "" {
//                    Spacer()
//                      // ⭐️최근 검색어 리스트 불러오기
//                } else {
//                    ScrollView {
//                        VStack {
//                            ForEach(musicList) { musicItem in
//                              // ⭐️MusicListRowView()에 대한 이해도 높이기 -> 특히, musicListRowType
//                              // ⭐️여기에서는 검색 결과로 내가 저장한 목록이 아닌 MusicKit에서 가져온 음악에 대한 목록이기 떄문에 내가 저장한 리스트와 저장하지 않은 단순히 검색 결과에 대한 리스트가 셖여서 나올텐데... 아니면 여기에서는 저장이 되어있든 아니든 그저 MusicKit에서 가져온 음악에 대한 리스트로 보이고 그 리스트에 대한 내가 저장을 한 여부는 알 수 없게...?
                
//                                MusicListRowView(
//                                    imageName: (musicItem.savedImage != nil) ? musicItem.savedImage! :  "annotation0",
//                                    songName: musicItem.songName,
//                                    artistName: musicItem.artistName,
//                                    musicListRowType: .notsaved,
//                                    buttonEllipsisAction: {
//
//                                    }
//                                )
//                            }
//                        }
//                    }
//                }
//                .onChange(of:searchTerm, perform: requestUpdateSearchResults)
                
                
                List {  // 노래들을 표시하기 위한 리스트 뷰
                    ForEach(songs, id: \.self) { song in
                    // 'ForEach'로 'songs'에 저장된 노래들을 반복하여 표시
                    // ForEach는 주어진 collection의 데이터를 기반으로 View들을 계산하는 Struct구조
                    // ForEach(array, id: \.self) name in
                    // id: \.self 부분은 SwiftUI가 배열의 각 요소를 고유하게 식별할 수 있도록 하기 위해 필요 (항목을 추가하거나 제거하면 SwiftUI가 정확히 어떤 요소가 추가되었는지 제거되었는지 확인 가능
                        
                        MusicItemCell(artwork: song.artwork, title: song.title, subtitle: song.id.rawValue)
                        
                        
                    }
                    
                }
                .animation(.default, value: songs)
            }
            .navigationTitle("Music Songs")
        }
        .searchable(text: $searchTerm, prompt: "Songs")
        // iOS 15 이상에서 제공되는 기능으로, 검색 기능을 뷰에 추가
        // 'searchTerm'이 변경되면 검색 요청이 실행
        
        .onChange(of: searchTerm, perform: requestUpdateSearchResults)
        // 'searchTerm'의 값이 변경될 때마다 'requestUpdateSearchResults'함수가 호출
        
        //.musicAuthViewSheet()
    }
    
    
    
    
    // 'requestUpdateSearchResults'함수는 주어진 'searchTerm'을 기반으로 노래를 검색
    // 만약 'searchTerm'이 비어있다면 검색 결과를 초기화하고, 그렇지 않으면 'MusicCatalogSearchRequest'를 사용하여 Apple Music 카탈로그에 검색 요청을 보내고 응답을 받아와 검색 결과를 업데이트
    // 검색 요청 중에 오류가 발생하면 오류를 처리하고 검색 결과를 초기화
    
    private func requestUpdateSearchResults(for searchTerm: String) {
    // requestUpdateSearchResults라는 private 함수를 선언하며, 함수의 매개변수로 'searchTerm'이라는 문자열을 받음
    // 이 함수는 주어진 'searchTerm'을 기반으로 검색 결과를 업데이트하는 역할을 함
        
        Task {
        // 비동기 처리를 위한 Task 블록으로, 비동기 함수 안에서 검색 요청을 처리. 백그라운드 스레드에서 비동기적으로 실행됨.
        // Task는 async 작업의 단위이며, swift에서 DispatchQueue나 OperationQueue, Thread 따로 없이 작성하면 main thread인 sync로 동작하는데, 이때 Task 블록으로 감싸서 async 코드를 수행할 수 있도록 제공
            if searchTerm.isEmpty {
            // 'searchTerm'이 비어있는지 (즉, 사용자가 검색어를 입력하지 않은 경우)를 확인하는 조건문
                await self.reset()
                // 만약 'searchTerm'이 비어있다면, 'reset()'함수를 호출하여 검색 결과를 초기화
                // 'reset()' 함수를 통해 'songs' 변수를 비워서 검색 결과를 초기화하는 역할
            } else {
                do {    // do 절에서 오류를 던지고, catch 절에서 오류를 전달받아 예외처리
                    var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
                    // MusicCatalogSearchRequest'는 MusicKit의 클래스로, 음악 카탈로그에서 검색을 요청하기 위해 사용
                    // 여기서는 노래들을 검색하도록 설정
                    // 만약 'searchTerm'이 비어 있지 않다면, 'MusicCatalogSearchRequest' 객체를 생성하여 제공된 'searchTerm'과 검색 대상인 'Song.self'타입을 사용하여 검색 요청을 생성
                    
                    searchRequest.limit = 5
                    // 'searchRequest'의 'limit'속성을 5로 설정
                    // 검색 결과로 최대 5개의 항목을 반환하도록 설정
                    
                    let searchResponse = try await searchRequest.response()
                    // searchRequest.response()를 통해 실제 검색 요청을 보내고 비동기 응답을 기다림
                    // 'searchRequest'객체의 'response()'함수를 호출하여 Apple Music 카탈로그에 검색 요청을 보내고 응답을 기다림
                    
                    await self.apply(searchResponse, for: searchTerm)
                    // 검색 결과를 처리하기 위해 검색 응답을 받은 후, 'apply(_:for:)'함수를 호출
                    // 이때 'searchResponse'(검색 결과)와 'searchTerm'이 'apply'함수에 인자로 전달
                    // apply(_:for:)는 검색 결과를 UI에 적용하는 메서드로, 이 메서드는 검색어가 변경된 후에만 앨범 결과를 UI에 반영
                } catch {
                // 검색 중에 오류가 발생한 경우, 'catch'블록 안에 있는 코드가 실행
                    print("search request failed")
                    await self.reset()
                    // 검색 요청이 실패한 경우, 'reset()'함수를 호출하여 검색 결과를 초기화
                    // reset() 검색어가 비워질 때 결과를 초기화하는 메서드
                }
            }
        }
    }
    
    
    @MainActor
    // 메인 스레드에서 실행되도록 지정된 함수
    // SwiftUI와 함께 비동기 코드를 작성할 때 메인 스레드에서 UI 업데이트를 수행해야 함.
    
    private func apply(_ searchResponse: MusicCatalogSearchResponse, for searchTerm: String) {
        if self.searchTerm == searchTerm {
        // 검색어가 최신인지 확인하여 race condition을 방지 (최신 검색어가 아닐 경우 결과를 업데이트하지 않음)
            
            self.songs = searchResponse.songs
            // 검색 결과로 받은 노래들을 'songs'변수에 저장
        }
    }
    
    
    @MainActor
    private func reset(){
        self.songs = []
        // 'songs'변수를 초기화하여 검색 결과를 삭제
    }
}

struct MusicSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MusicSearchView()
    }
}
