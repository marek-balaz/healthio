//
//  UserProfileDBRepository.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import Combine
import CoreData

protocol UsersDBRepository {
    
    func store(userProfile: UserProfile) -> AnyPublisher<Void, Error>
    
    func edit(userProfile: UserProfile) -> AnyPublisher<Void, Error>
    
    func delete(userProfileId: UUID) -> AnyPublisher<Void, Error>
    
    func fetch(search: String) -> AnyPublisher<[UserProfile], Error>
    
}

struct UsersDBRepositoryImpl: UsersDBRepository {
    
    let persistentStore: PersistentStore
    
    init(
        persistentStore: PersistentStore
    ) {
        self.persistentStore = persistentStore
    }
    
    func store(
        userProfile: UserProfile
    ) -> AnyPublisher<Void, Error> {
        persistentStore.update { context in
            userProfile.store(in: context)
        }
    }
    
    func edit(
        userProfile: UserProfile
    ) -> AnyPublisher<Void, Error> {
        persistentStore.update { context in
            do {
                let parentRequest = UserProfileMO.currentUser(userProfile.id)
                guard let oldUserProfile = try context.fetch(parentRequest).first else {
                    throw AppError.domain(.data(.unexpectedError))
                }
                
                oldUserProfile.userId = userProfile.userId
                oldUserProfile.name = userProfile.name
                oldUserProfile.avatar = userProfile.avatar
                oldUserProfile.birthDate = userProfile.birthDate
                oldUserProfile.weight = userProfile.weight
                oldUserProfile.height = userProfile.height
            } catch {
                throw error
            }
        }
    }
    
    func delete(
        userProfileId: UUID
    ) -> AnyPublisher<Void, Error> {
        persistentStore.update { context in
            do {
                let request = UserProfileMO.currentUser(userProfileId)
                guard let userProfileMO = try context.fetch(request).first else {
                    throw AppError.domain(.data(.unexpectedError))
                }
                context.delete(userProfileMO)
            } catch {
                throw error
            }
        }
    }
    
    func fetch(
        search: String
    ) -> AnyPublisher<[UserProfile], Error> {
        let fetchRequest: NSFetchRequest<UserProfileMO> = UserProfileMO.users(search: search)
        return persistentStore.fetch(fetchRequest) { userProfileMO in
            return UserProfile(managedObject: userProfileMO)
        }
    }
    
}

extension UserProfileMO {
    
    static func users(search: String) -> NSFetchRequest<UserProfileMO> {
        let request = NSFetchRequest<UserProfileMO>(entityName: UserProfileMO.entityName)
        if search.isEmpty {
            request.predicate = NSPredicate(value: true)
        } else {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", search)
        }
        return request
    }
    
    static func currentUser(_ id: UUID) -> NSFetchRequest<UserProfileMO> {
        let request = NSFetchRequest<UserProfileMO>(entityName: UserProfileMO.entityName)
        request.predicate = NSPredicate(format: "userId == %@", id as CVarArg)
        return request
    }
    
}

