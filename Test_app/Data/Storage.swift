import Foundation
import CoreData
import UIKit

public final class fetchArticles: NSObject {
    public static let shared = fetchArticles()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func create(id: Int64, url: String, title: String) {
        guard let storageEntityDescription = NSEntityDescription.entity(forEntityName: "StorageArticlee", in: context) else {
            return
        }
        let obg = StorageArticlee(entity: storageEntityDescription, insertInto: context)
        obg.id = id
        obg.url = url
        obg.title = title
        appDelegate.saveContext()
    }
    
    public func fetch() -> [StorageArticlee] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StorageArticlee")
        do {
            return (try? context.fetch(fetchRequest) as? [StorageArticlee]) ?? []
        }
    }
    
    public func deletaAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StorageArticlee")
        do {
            let obg = try? context.fetch(fetchRequest) as? [StorageArticlee]
            obg?.forEach { context.delete($0) }
        }
        appDelegate.saveContext()
    }
    
    public func deletaOne(with id: Int64) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StorageArticlee")
        do {
            guard let obgs = try? context.fetch(fetchRequest) as? [StorageArticlee],
                  let obg = obgs.first(where: { $0.id == id }) else { return}
            context.delete(obg)
        }
        appDelegate.saveContext()
    }
    
    public func updata(with id: Int64, nevFav: Bool ) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StorageArticlee")
        do {
            guard let obgs = try? context.fetch(fetchRequest) as? [StorageArticlee],
                  let obg = obgs.first(where: { $0.id == id }) else { return}
            obg.fav = nevFav
        }
        appDelegate.saveContext()
    }
    
    func searchObjectByID(id: Int64) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "StorageArticlee")
        let predicate = NSPredicate(format: "id == %lld", id)
        fetchRequest.predicate = predicate
        do {
            let results = try context.fetch(fetchRequest)
            return results.count > 0
        } catch {
            print("Помилка при виконанні запиту до Core Data: \(error)")
            return false
        }
    }
    
}

class cachePage {
    func cacheWebPage(urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Помилка кешування веб-сторінки: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                }
            }
            task.resume()
        }
    }
    
    func removeWebPageFromCache(urlString: String) {
        if let url = URL(string: urlString) {
            URLCache.shared.removeCachedResponse(for: URLRequest(url: url))
        }
    }
}


