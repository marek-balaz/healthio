//
//  BloodPressureDBRepository.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import Combine
import CoreData

protocol BloodPressureDBRepository {
    
    func add(bloodPressure: BloodPressure) -> AnyPublisher<Void, Error>
    
    func edit(bloodPressure: BloodPressure) -> AnyPublisher<Void, Error>
    
    func delete(bloodPressure: BloodPressure) -> AnyPublisher<Void, Error>
    
    func fetchAll(_ userId: UUID?) -> AnyPublisher<[BloodPressure], Error>
    
}

struct BloodPressureDBRepositoryImpl: BloodPressureDBRepository {
    
    let persistentStore: PersistentStore
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
    }
    
    func add(bloodPressure: BloodPressure) -> AnyPublisher<Void, Error> {
        return persistentStore.update { context in
            let bloodPressureMO = BloodPressureMO(context: context)
            bloodPressureMO.userId = bloodPressure.userId
            bloodPressureMO.timestamp = bloodPressure.timestamp
            bloodPressureMO.diastolic = Int32(bloodPressure.diastolic)
            bloodPressureMO.systolic = Int32(bloodPressure.systolic)
            bloodPressureMO.pulse = Int32(bloodPressure.pulse)
            try context.save()
        }
    }
    
    func edit(bloodPressure: BloodPressure) -> AnyPublisher<Void, Error> {
        return persistentStore.update { context in
            let fetchRequest: NSFetchRequest<BloodPressureMO> = BloodPressureMO.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "userId == %@", bloodPressure.id as CVarArg)
            
            if let bloodPressureMO = try context.fetch(fetchRequest).first {
                bloodPressureMO.userId = bloodPressure.userId
                bloodPressureMO.timestamp = bloodPressure.timestamp
                bloodPressureMO.diastolic = Int32(bloodPressure.diastolic)
                bloodPressureMO.systolic = Int32(bloodPressure.systolic)
                bloodPressureMO.pulse = Int32(bloodPressure.pulse)
                try context.save()
            } else {
                throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("global_repo_error", comment: "")])
            }
        }
    }
    
    func delete(bloodPressure: BloodPressure) -> AnyPublisher<Void, Error> {
        return persistentStore.update { context in
            let fetchRequest: NSFetchRequest<BloodPressureMO> = BloodPressureMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "userId == %@", bloodPressure.id as CVarArg)
            if let bloodPressureMO = try context.fetch(fetchRequest).first {
                context.delete(bloodPressureMO)
                try context.save()
            } else {
                throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("global_repo_error", comment: "")])
            }
        }
    }
        
    func fetchAll(_ userId: UUID?) -> AnyPublisher<[BloodPressure], Error> {
        let fetchRequest: NSFetchRequest<BloodPressureMO> = BloodPressureMO.records(userId)
        return self.persistentStore.fetch(fetchRequest) { bloodPressureMO in
            return BloodPressure(managedObject: bloodPressureMO)
        }
    }
    
}

extension BloodPressureMO {
    
    static func records(_ userId: UUID?) -> NSFetchRequest<BloodPressureMO> {
        let request = NSFetchRequest<BloodPressureMO>(entityName: BloodPressureMO.entityName)
        var predicates: [NSPredicate] = []

        if let userId {
            let searchPredicate = NSPredicate(format: "userId == %@", userId as CVarArg)
            predicates.append(searchPredicate)

            request.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        } else {
            request.predicate = NSPredicate(value: true)
        }
        
        return request
    }
    
}

