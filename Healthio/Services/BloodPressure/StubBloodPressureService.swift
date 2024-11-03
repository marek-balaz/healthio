//
//  StubBloodPressureService.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import Combine

struct StubBloodPressureService: BloodPressureService {
    
    func store(bloodPressureRecords: [BloodPressure], for userProfileId: UUID) -> AnyPublisher<Void, Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func edit(bloodPressure: BloodPressure) -> AnyPublisher<Void, Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func delete(bloodPressureId: UUID) -> AnyPublisher<Void, Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func fetch(interval: Interval, for userProfileId: UUID) -> AnyPublisher<[BloodPressure], Error> {
        Future { promise in
            promise(.success(([])))
        }
        .eraseToAnyPublisher()
    }
    
    func bloodPressureCategory(systolic: Int, diastolic: Int) -> BloodPressureCategory {
        return .unknown
    }
    
}

