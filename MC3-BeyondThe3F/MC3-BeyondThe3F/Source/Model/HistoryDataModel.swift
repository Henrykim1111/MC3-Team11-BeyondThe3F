import Foundation
import CoreData


class HistoryDataModel {
    static let shared = HistoryDataModel()
    private init() {}
    
    private let limit = 30
    
    weak var delegate:MusicItemDataModelDelegate?
    
    var persistentContainer = PersistenceController.shared.container
    
    func saveData(musicId:String,songName:String){
        
        self.removeByMusicId(musicId: musicId)
        
        let newItem = History(context: persistentContainer.viewContext)
        
        newItem.musicId = musicId
        newItem.songName = songName
        newItem.date = Date()
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    var history: [History] {
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Fetch request failed: \(error)")
            return []
        }
    }
    var readRecentHistory:[History]{
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = self.limit

        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Fetch recent history failed: \(error)")
            return []
        }
    }
    
    func readByMusicId(musicId: String, limit: Int = 30) -> [History] {
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "musicId == %@", musicId)
        fetchRequest.fetchLimit = limit

        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Fetch recent history with musicId failed: \(error)")
            return []
        }
    }
    
    
    func removeByMusicId(musicId: String) {
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "musicId == %@", musicId)
        
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            
            for object in results {
                persistentContainer.viewContext.delete(object)
            }
            
            try persistentContainer.viewContext.save()
        } catch {
            print("Delete by musicId failed: \(error)")
        }
    }


    func removeAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = History.fetchRequest()
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try persistentContainer.viewContext.execute(batchDeleteRequest)
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to delete all history: \(error)")
        }
    }

}
