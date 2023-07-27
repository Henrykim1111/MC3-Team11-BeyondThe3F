//
//  SearchDataModel.swift
//  MC3-BeyondThe3F
//
//  Created by jaesik pyeon on 2023/07/25.
//

import Foundation
import MusicKit

class SearchDataModel{
    static let shared = SearchDataModel()
    private init(){}
    
    func requestUpdateSearchResults(for searchTerm: String) async -> MusicCatalogSearchResponse? {
        do {
            var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
            searchRequest.limit = 5
            let searchResponse = try await searchRequest.response()
            return searchResponse
        } catch {
            print("search request failed")
            return nil
        }
    }
}
