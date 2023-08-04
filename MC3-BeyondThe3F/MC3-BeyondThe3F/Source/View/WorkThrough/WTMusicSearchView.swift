//
//  WTMusicSearchView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/29.
//

import MusicKit
import SwiftUI

struct WTMusicSearchView: View {
    @AppStorage("isFirst") private var isFirst = true
    @ObservedObject private var musicSearchViewModel = MusicSearchViewModel()
    
    @State private var searchTerm = ""
    @State private var showSearchView = true
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: 30)
                    Text("안녕하세요!\n요즘 가장 많이 듣는 노래를 알려주세요.")
                        .lineSpacing(5)
                        .headline(color: .white)
                        .padding(.bottom, 8)
                    Text("음악명으로 검색해주세요.")
                        .body2(color: .gray500)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 16)
                }
                
                MusicSearchComponentView(
                    searchTerm: $searchTerm,
                    showSearchView: $showSearchView,
                    isShazamEnabled: false
                )
                
                Spacer()
                switch musicSearchViewModel.musicSearchState {
                case .notSearched:
                    EmptyView()
                case .searching:
                    HStack{
                        Spacer()
                        ProgressView("음악 검색 중")
                            .foregroundColor(Color.custom(.gray400))
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.custom(.gray400)))
                        Spacer()
                    }
                case .notFound:
                    HStack {
                        Spacer()
                        Text("해당하는 노래를 찾지 못했습니다.")
                            .body2(color: .gray400)
                        Spacer()
                    }
                case .success:
                    MusicSearchResultsList
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 20)
            .background(Color.custom(.background))
        }
        .accentColor(Color.custom(.white))
        .onChange(of: searchTerm, perform: musicSearchViewModel.requestUpdateSearchResults)
        .onAppear {
            Task {
                await MusicAuthManger.requestMusicAuth()
            }
        }
    }
}

extension WTMusicSearchView {
    // TODO: 스크롤을 더 내릴 경우 다음 페이지의 음악 list를 request 요청
    private var MusicSearchResultsList: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    Spacer()
                }
                .padding(.top, 20)
                ForEach(musicSearchViewModel.searchSongs, id: \.self) { songItem in
                    MusicSeachedItemRowComponentView(songItem: songItem) {
                        MusicItemUpdateViewModel.shared.updateMusicItemFromMusicId(musicId: songItem.id.rawValue)
                    }
                }
            }
        }
    }
}


struct WTMusicSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WTMusicSearchView()
    }
}
