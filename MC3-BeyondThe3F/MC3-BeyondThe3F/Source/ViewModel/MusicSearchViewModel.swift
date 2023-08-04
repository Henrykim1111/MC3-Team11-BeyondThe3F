//
//  MusicSearchViewModel.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/26.
//

import MusicKit
import SwiftUI

struct SearchItem: Identifiable {
    let id = UUID()
    var searchText: String
    var stringDate: String
    var searchDate: Date
}

enum MusicSearchState {
    case notSearched
    case searching
    case success
    case notFound
}

class MusicSearchViewModel: ObservableObject {
    
    private let historymodel = HistoryDataModel.shared
    
    @Published var resentlySearchList: [History] = HistoryDataModel.shared.readRecentHistory
    @Published var searchSongs: MusicItemCollection<Song> = []
    @Published var musicSearchState: MusicSearchState = .notSearched
    
    
    func requestUpdateSearchResults(for searchTerm: String) {
        Task {
            await self.changeSearchState(state: .searching)
            if searchTerm.isEmpty {
                await self.changeSearchState(state: .notSearched)
                await self.reset()
            } else {
                do {
                    var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
                    searchRequest.limit = 10
                    let searchResponse = try await searchRequest.response()
                    await self.changeSearchState(state: .success)
                    await self.apply(searchResponse, for: searchTerm)
                } catch {
                    await self.changeSearchState(state: .notFound)
                    await self.reset()
                }
            }
        }
    }
    
    func addMusicHistory(musicId: String, songName: String){
        historymodel.saveData(musicId: musicId, songName: songName)
        readHistoryData()
    }
    
    func removeMusicHistoryById(musicId: String){
        if !musicId.isEmpty {
            historymodel.removeByMusicId(musicId: musicId)
            readHistoryData()
        }
    }
    
    func removeAllMusicHistory(){
        historymodel.removeAll()
        readHistoryData()
    }
    
    private func playMusic(musicId: String){
        // TODO: musicListRow를 클릭한 경우 해당 음악이 playMusic에 추가되는 기능 구현 필요
    }
    
    private func readHistoryData(){
        resentlySearchList = historymodel.readRecentHistory
    }
    
    @MainActor
    private func apply(_ searchResponse: MusicCatalogSearchResponse, for searchTerm: String) {
        self.searchSongs = searchResponse.songs
        if searchSongs.isEmpty {
            self.musicSearchState = .notFound
        }
    }
    
    
    @MainActor
    private func reset() {
        self.searchSongs = []
    }
    
    @MainActor
    private func changeSearchState(state: MusicSearchState) {
        self.musicSearchState = state
    }
}
