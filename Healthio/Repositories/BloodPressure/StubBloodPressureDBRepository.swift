//
//  StubBloodPressureDBRepository.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import Combine
import CoreData

struct StubBloodPressureDBRepository: BloodPressureDBRepository {
    
    func add(bloodPressure: BloodPressure) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func edit(bloodPressure: BloodPressure) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func delete(bloodPressure: BloodPressure) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func fetchAll(_ userId: UUID?) -> AnyPublisher<[BloodPressure], any Error> {
        Future { promise in
            promise(.success([]))
        }
        .eraseToAnyPublisher()
    }
    
}
