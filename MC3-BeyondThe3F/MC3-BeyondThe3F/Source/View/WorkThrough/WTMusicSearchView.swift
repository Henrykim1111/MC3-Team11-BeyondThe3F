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
    @StateObject private var musicSearchViewModel = MusicSearchViewModel()
    @StateObject private var musicItemUpdateViewModel = MusicItemUpdateViewModel.shared
    
    @State private var searchTerm = ""
    @State private var showSearchView = true
    
    let musicItemDataModel = MusicItemDataModel.shared
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: 124)
                Text("안녕하세요!\n요즘 가장 많이 듣는 노래를 알려주세요.")
                    .lineSpacing(5)
                    .headline(color: .white)
                Spacer()
                    .frame(height: 16)
                Text("음악명으로 검색해주세요.")
                    .body2(color: .gray500)
                    .multilineTextAlignment(.leading)
                Spacer()
                    .frame(height: 32)
                MusicSearchComponentView(
                    searchTerm: $searchTerm,
                    showSearchView: $showSearchView,
                    isShazamEnabled: false
                )
                switch musicSearchViewModel.musicSearchState {
                case .notSearched:
                    Spacer()
                        .frame(height: 16)
                case .searching:
                    Spacer()
                        .frame(height: 56)
                    HStack{
                        Spacer()
                        ProgressView("음악 검색 중")
                            .foregroundColor(Color.custom(.gray400))
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.custom(.gray400)))
                        Spacer()
                    }
                case .notFound:
                    Spacer()
                        .frame(height: 56)
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
            .padding(.horizontal, 20)
            .background(Color.custom(.background))
            .edgesIgnoringSafeArea(.all)
        }
        .accentColor(Color.custom(.white))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: searchTerm, perform: musicSearchViewModel.requestUpdateSearchResults)
        .onAppear {
            Task {
                await MusicAuthManger.requestMusicAuth()
            }
        }
    }
}

extension WTMusicSearchView {
    // TODO: 스크롤을 더 내릴 경우 다음 페이지의 음악 list를 request해서 보여줘야함
    private var MusicSearchResultsList: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    Spacer()
                }
                ForEach(musicSearchViewModel.searchSongs, id: \.self) { item in
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
                                .truncationMode(.tail)
                                .lineLimit(1)
                                .padding(.bottom, 4)
                            Text(item.artistName)
                                .body2(color: .gray500)
                                .truncationMode(.tail)
                                .lineLimit(1)
                        }
                        Spacer()
                        NavigationLink {
                            EditMapPositionView(nextProcess: .forward)
                                .navigationBarBackButtonHidden(true)
                                .simultaneousGesture(TapGesture().onEnded {
                                    musicItemUpdateViewModel.updateMusicItemFromMusicId(musicId: item.id.rawValue)
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


struct WTMusicSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WTMusicSearchView()
    }
}
