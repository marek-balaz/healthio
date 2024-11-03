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
    
    func store(bloodPressureRecords: [BloodPressure], for userProfileId: UUID) -> AnyPublisher<Void, Error>
    
    func edit(bloodPressure: BloodPressure) -> AnyPublisher<Void, Error>
    
    func delete(bloodPressureId: UUID) -> AnyPublisher<Void, Error>
    
    func fetch(interval: Interval, for userProfileId: UUID) -> AnyPublisher<[BloodPressure], Error>
    
}

struct BloodPressureDBRepositoryImpl: BloodPressureDBRepository {
    
    let persistentStore: PersistentStore
    
    init(
        persistentStore: PersistentStore
    ) {
        self.persistentStore = persistentStore
    }
    
    func store(
        bloodPressureRecords: [BloodPressure],
        for userProfileId: UUID
    ) -> AnyPublisher<Void, Error> {
        persistentStore.update { context in
            do {
                let parentRequest = UserProfileMO.currentUser(userProfileId)
                guard let parent = try context.fetch(parentRequest).first else {
                    throw AppError.domain(.data(.notFound))
                }
                for record in bloodPressureRecords {
                    record.store(in: context, user: parent)
                }
            } catch {
                throw error
            }
        }
    }
    
    func edit(
        bloodPressure: BloodPressure
    ) -> AnyPublisher<Void, Error> {
        persistentStore.update { context in
            do {
                let parentRequest = UserProfileMO.currentUser(bloodPressure.userId)
                guard let userProfileMO = try context.fetch(parentRequest).first else {
                    throw AppError.domain(.data(.notFound))
                }
                
                let selfRequest = BloodPressureMO.getRecord(bloodPressure.id)
                guard let bloodPressureMO = try context.fetch(selfRequest).first else {
                    throw AppError.domain(.data(.notFound))
                }
                
                bloodPressureMO.user = userProfileMO
                bloodPressureMO.diastolic = Int32(bloodPressure.diastolic)
                bloodPressureMO.systolic = Int32(bloodPressure.systolic)
                bloodPressureMO.pulse = Int32(bloodPressure.pulse)
                bloodPressureMO.timestamp = bloodPressure.timestamp
            } catch {
                throw error
            }
        }
    }
    
    func delete(
        bloodPressureId: UUID
    ) -> AnyPublisher<Void, Error> {
        persistentStore.update { context in
            do {
                let request = BloodPressureMO.getRecord(bloodPressureId)
                guard let bloodPressureMO = try context.fetch(request).first else {
                    throw AppError.domain(.data(.notFound))
                }
                context.delete(bloodPressureMO)
            } catch {
                throw error
            }
        }
    }
    
    func fetch(
        interval: Interval,
        for userProfileId: UUID
    ) -> AnyPublisher<[BloodPressure], Error> {
        let fetchRequest: NSFetchRequest<BloodPressureMO> = BloodPressureMO.records(interval, for: userProfileId)
        return persistentStore.fetch(fetchRequest) { bloodPressureMO in
            return BloodPressure(managedObject: bloodPressureMO)
        }
    }
    
}

extension BloodPressureMO {
    static func getRecord(_ id: UUID) -> NSFetchRequest<BloodPressureMO> {
        let request = NSFetchRequest<BloodPressureMO>(entityName: BloodPressureMO.entityName)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return request
    }
    
    static func records(
        _ interval: Interval,
        for userProfileId: UUID
    ) -> NSFetchRequest<BloodPressureMO> {
        let request = NSFetchRequest<BloodPressureMO>(entityName: BloodPressureMO.entityName)
        
        let endDate = Date()
        var predicate: NSPredicate

        if interval != .all {
            let startDate = Calendar.current.date(byAdding: .day, value: -interval.rawValue, to: endDate)!
            predicate = NSPredicate(
                format: "user.userId == %@ AND timestamp >= %@ AND timestamp <= %@",
                userProfileId as CVarArg,
                startDate as CVarArg,
                endDate as CVarArg
            )
        } else {
            predicate = NSPredicate(format: "user.userId == %@")
        }
        
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        return request
    }
}
