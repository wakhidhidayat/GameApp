//
//  FavoriteProvider.swift
//  GameApp
//
//  Created by Wahid Hidayat on 12/08/21.
//

import Foundation
import CoreData

class FavoriteProvider {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameApp")
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        taskContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return taskContext
    }
    
    func createFavorite(
        _ id: Int,
        _ name: String,
        _ backgroundImage: Data,
        _ poster: Data,
        _ description: String,
        _ released: String,
        _ rating: String,
        completion: @escaping() -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.perform {
            if let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                game.setValue(id, forKey: "id")
                game.setValue(name, forKey: "name")
                game.setValue(backgroundImage, forKey: "backgroundImage")
                game.setValue(poster, forKey: "poster")
                game.setValue(description, forKey: "overview")
                game.setValue(released, forKey: "released")
                game.setValue(rating, forKey: "rating")
                
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func getFavorites(completion: @escaping(_ favorites: [Favorite]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var favorites: [Favorite] = []
                for result in results {
                    let favorite = Favorite(
                        id: result.value(forKey: "id") as? Int,
                        name: result.value(forKey: "name") as? String,
                        released: result.value(forKey: "released") as? String,
                        poster: result.value(forKey: "poster") as? Data,
                        rating: result.value(forKey: "rating") as? String,
                        backgroundImage: result.value(forKey: "backgroundImage") as? Data,
                        description: result.value(forKey: "overview") as? String
                    )
                    favorites.append(favorite)
                }
                completion(favorites)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func checkDataExistence(_ id: Int) -> Bool {
        var isExist = false
        let taskContext = newTaskContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        do {
            let result = try taskContext.fetch(fetchRequest)
            if result.count > 0 {
                isExist = true
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return isExist
    }
    
    func deleteFavorite(_ id: Int, completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult =
                try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                completion()
            }
        }
    }
}
