//
//  MusicItemDataModel.swift
//  MC3-BeyondThe3F
//
//  Created by jaesik pyeon on 2023/07/20.
//

import Foundation
import CoreData

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
    
    func saveMusicItem(musicItemVO:MusicItemVO){

        let newItem = MusicItem(context: persistentContainer.viewContext)
        
        newItem.musicId = musicItemVO.musicId
        newItem.desc = musicItemVO.desc
        newItem.latitude = musicItemVO.latitude
        newItem.longitude = musicItemVO.longitude
        newItem.locationInfo = musicItemVO.locationInfo
        newItem.playedCount = Int32(musicItemVO.playedCount)
        newItem.savedImage = musicItemVO.savedImage
        newItem.generatedDate = musicItemVO.generatedDate
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    var mainMusic:[String:[MusicItemVO]]{
        var items:[String:[MusicItemVO]] = [:]
        for music in musicList {
            if var item = items[music.locationInfo ?? ""]{
                item.append(MusicItemVO(musicId: music.musicId ?? "", latitude: music.latitude, longitude: music.longitude, playedCount: Int(music.playedCount), songName: "", artistName: "", generatedDate: Date()))
                items[music.locationInfo ?? ""] = item
            }else{
                items[music.locationInfo ?? ""] = [MusicItemVO(musicId: music.musicId ?? "", latitude: music.latitude, longitude: music.longitude, playedCount: Int(music.playedCount), songName: "", artistName: "", generatedDate: Date())]
            }
        }
        return items
    }
}
