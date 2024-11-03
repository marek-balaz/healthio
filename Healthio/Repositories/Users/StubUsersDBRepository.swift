//
//  StubUserProfileDBRepository.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import Combine
import CoreData

struct StubUsersDBRepository: UsersDBRepository {
    
    func store(userProfile: UserProfile) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func edit(userProfile: UserProfile) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func delete(userProfileId: UUID) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func fetch(search: String) -> AnyPublisher<[UserProfile], any Error> {
        Future { promise in
            promise(.success([]))
        }
        .eraseToAnyPublisher()
    }
    
}
