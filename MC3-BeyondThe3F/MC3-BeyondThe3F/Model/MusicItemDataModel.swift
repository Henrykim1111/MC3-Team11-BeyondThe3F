//
//  MusicItemDataModel.swift
//  MC3-BeyondThe3F
//
//  Created by jaesik pyeon on 2023/07/20.
//

import Foundation
import CoreData
import MusicKit
import SwiftUI

protocol MusicItemDataModelDelegate:AnyObject{
    func musicItemDataModel()->Void
}
class MusicItemDataModel {
    static let shared = MusicItemDataModel()
    private init() {}
    
    weak var delegate:MusicItemDataModelDelegate?
    
    var persistentContainer = PersistenceController.shared.container
    
    var musicList: [MusicItem] {
        let fetchRequest: NSFetchRequest<MusicItem> = MusicItem.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Fetch request failed: \(error)")
            return []
        }
    }
    func deleteMusicItemWith(musicId: String, locationInfo: String) {
        let fetchRequest: NSFetchRequest<MusicItem> = MusicItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "musicId == %@ AND locationInfo == %@", musicId, locationInfo)

        do {
            let items = try persistentContainer.viewContext.fetch(fetchRequest)
            for item in items {
                persistentContainer.viewContext.delete(item)
            }
            try persistentContainer.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func saveMusicItem(musicItemVO:MusicItemVO) {
        self.deleteMusicItemWith(musicId: musicItemVO.musicId, locationInfo: musicItemVO.locationInfo)
        let newItem = MusicItem(context: persistentContainer.viewContext)

        newItem.musicId = musicItemVO.musicId
        newItem.latitude = musicItemVO.latitude
        newItem.longitude = musicItemVO.longitude
        newItem.locationInfo = musicItemVO.locationInfo
        newItem.savedImage = musicItemVO.savedImage
        newItem.generatedDate = musicItemVO.generatedDate
        newItem.songName = musicItemVO.songName
        newItem.artistName = musicItemVO.artistName
    
        do {
            try persistentContainer.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func getURL(_ musicId: String) async -> URL? {
        do {
            var searchRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: MusicItemID(musicId))
            let searchResponse = try await searchRequest.response()
    
            guard let imageURL = searchResponse.items.first?.artwork?.url(width: 700, height: 700) else{
                return nil
            }
            return imageURL
        } catch {
            print("search request failed")
            return nil
        }
    }
    
    func getInfoByMusicId(_ musicId: String) async -> MusicCatalogResourceResponse<Song>? {
        do {
            var searchRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: MusicItemID(musicId))
            let searchResponse = try await searchRequest.response()
            
            return searchResponse
        } catch {
            print("search request failed")
            return nil
        }
    }
}
