//
//  StubUserProfileService.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import Combine
import CoreData

struct StubUsersService: UsersService {
  
    func getSelectedUser(id: UUID?) {
        
    }
    
    func addUser(_ userProfile: UserProfile) -> AnyPublisher<Void, Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func editUser(_ userProfile: UserProfile) -> AnyPublisher<Void, Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func deleteUser(_ id: UUID) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }

    func fetchUsers(search: String) -> AnyPublisher<[UserProfile], Error> {
        Future { promise in
            promise(.success([]))
        }
        .eraseToAnyPublisher()
    }
    
}
