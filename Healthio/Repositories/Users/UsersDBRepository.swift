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
    
    func add(userProfile: UserProfile) -> AnyPublisher<Void, Error>
    
    func edit(userProfile: UserProfile) -> AnyPublisher<Void, Error>
    
    func delete(userProfile: UserProfile) -> AnyPublisher<Void, Error>
    
    func fetch(search: String) -> AnyPublisher<[UserProfile], Error>
    
}

struct UsersDBRepositoryImpl: UsersDBRepository {
    
    let persistentStore: PersistentStore
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
    }
    
    func add(userProfile: UserProfile) -> AnyPublisher<Void, Error> {
        return persistentStore.update { context in
            let userProfileMO = UserProfileMO(context: context)
            userProfileMO.userId = userProfile.userId
            userProfileMO.name = userProfile.name
            userProfileMO.avatar = userProfile.avatar
            userProfileMO.birthDate = userProfile.birthDate
            userProfileMO.weight = userProfile.weight
            userProfileMO.height = userProfile.height
            try context.save()
        }
    }
    
    func edit(userProfile: UserProfile) -> AnyPublisher<Void, Error> {
        return persistentStore.update { context in
            let fetchRequest: NSFetchRequest<UserProfileMO> = UserProfileMO.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "userId == %@", userProfile.id as CVarArg)
            
            if let userProfileMO = try context.fetch(fetchRequest).first {
                userProfileMO.userId = userProfile.userId
                userProfileMO.name = userProfile.name
                userProfileMO.avatar = userProfile.avatar
                userProfileMO.birthDate = userProfile.birthDate
                userProfileMO.weight = userProfile.weight
                userProfileMO.height = userProfile.height
                try context.save()
            } else {
                throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("global_repo_error", comment: "")])
            }
        }
    }
    
    func delete(userProfile: UserProfile) -> AnyPublisher<Void, Error> {
        return persistentStore.update { context in
            let fetchRequest: NSFetchRequest<UserProfileMO> = UserProfileMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "userId == %@", userProfile.id as CVarArg)
            if let userProfileMO = try context.fetch(fetchRequest).first {
                context.delete(userProfileMO)
                try context.save()
            } else {
                throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("global_repo_error", comment: "")])
            }
        }
    }
        
    func fetch(search: String) -> AnyPublisher<[UserProfile], Error> {
        let fetchRequest: NSFetchRequest<UserProfileMO> = UserProfileMO.users(search: search)
        return self.persistentStore.fetch(fetchRequest) { userProfileMO in
            return UserProfile(managedObject: userProfileMO)
        }
    }
    
}

extension UserProfileMO {
    
    static func users(search: String) -> NSFetchRequest<UserProfileMO> {
        let request = NSFetchRequest<UserProfileMO>(entityName: UserProfileMO.entityName)
        var predicates: [NSPredicate] = []

        if search.isEmpty {
            request.predicate = NSPredicate(value: true)
        } else {
            if !search.isEmpty {
                let searchPredicate = NSPredicate(format: "firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@ OR phoneNumber CONTAINS[cd] %@", search, search, search)
                predicates.append(searchPredicate)
            }

            request.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        }

        return request
    }
    
}

