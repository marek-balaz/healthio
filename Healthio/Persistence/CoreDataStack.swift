//
//  CoreDataStack.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import CoreData
import Combine

protocol PersistentStore {
    
    typealias DBOperation<Result> = (NSManagedObjectContext) throws -> Result
    
    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error>
    
    func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>, map: @escaping (T) throws -> V?) -> AnyPublisher<[V], Error>
    
    func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error>
    
}

struct CoreDataStack: PersistentStore {
    
    private let container: NSPersistentContainer
    
    private let isStoreLoaded = CurrentValueSubject<Bool, Error>(false)
    
    private let bgQueue = DispatchQueue(label: "coredata", qos: .userInitiated)
    
    init(directory: FileManager.SearchPathDirectory = .documentDirectory,
         domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
         version vNumber: UInt) {
        let version = Version(vNumber)
        container = NSPersistentContainer(name: version.modelName)
        if let url = version.dbFileURL(directory, domainMask) {
            let store = NSPersistentStoreDescription(url: url)
            container.persistentStoreDescriptions = [store]
        }
        bgQueue.async { [weak isStoreLoaded, weak container] in
            container?.loadPersistentStores { (storeDescription, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        isStoreLoaded?.send(completion: .failure(error))
                    } else {
                        container?.viewContext.configureAsReadOnlyContext()
                        isStoreLoaded?.value = true
                    }
                }
            }
        }
    }
    
    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error> {
        Deferred {
            Future<Int, Error> { [weak container] promise in
                do {
                    let count = try container?.viewContext.count(for: fetchRequest) ?? 0
                    promise(.success(count))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .subscribe(on: bgQueue)
        .eraseToAnyPublisher()
    }
    
    func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>, map: @escaping (T) throws -> V?) -> AnyPublisher<[V], Error> {
        Deferred {
            Future<[V], Error> { [weak container] promise in
                guard let context = container?.viewContext else { return }
                context.performAndWait {
                    do {
                        let managedObjects = try context.fetch(fetchRequest)
                        let mappedObjects = try managedObjects.compactMap(map)
                        
                        // Refresh managed objects to turn them into faults
                        managedObjects.forEach { object in
                            if let mo = object as? NSManagedObject {
                                context.refresh(mo, mergeChanges: false)
                            }
                        }
                        
                        promise(.success(mappedObjects))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .subscribe(on: bgQueue)
        .eraseToAnyPublisher()
    }

    func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error> {
        Deferred {
            Future<Result, Error> { [weak container] promise in
                guard let context = container?.newBackgroundContext() else { return }
                context.configureAsUpdateContext()
                context.performAndWait {
                    do {
                        let result = try operation(context)
                        if context.hasChanges {
                            try context.save()
                        }
                        context.reset()
                        promise(.success(result))
                    } catch {
                        context.reset()
                        promise(.failure(error))
                    }
                }
            }
        }
        .subscribe(on: bgQueue)
        .eraseToAnyPublisher()
    }

}

// MARK: - Versioning

extension CoreDataStack.Version {
    static var actual: UInt { 1 }
}

extension CoreDataStack {
    struct Version {
        private let number: UInt
        
        init(_ number: UInt) {
            self.number = number
        }
        
        var modelName: String {
            return "db_model_v1"
        }
        
        func dbFileURL(_ directory: FileManager.SearchPathDirectory,
                       _ domainMask: FileManager.SearchPathDomainMask) -> URL? {
            return FileManager.default
                .urls(for: directory, in: domainMask).first?
                .appendingPathComponent(subpathToDB)
        }
        
        private var subpathToDB: String {
            return "db.sql"
        }
    }
}
