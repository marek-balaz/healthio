//
//  StubBloodPressureService.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import Combine

struct StubBloodPressureService: BloodPressureService {
    
    func addRecord(_ bloodPressure: BloodPressure) -> AnyPublisher<Void, Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func editRecord(_ bloodPressure: BloodPressure) -> AnyPublisher<Void, Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func deleteRecord(_ bloodPressure: BloodPressure) -> AnyPublisher<Void, Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func fetchRecords() -> AnyPublisher<[BloodPressure], Error> {
        Future { promise in
            promise(.success([]))
        }
        .eraseToAnyPublisher()
    }
    
    func bloodPressureCategory(systolic: Int, diastolic: Int) -> BloodPressureCategory {
        return .unknown
    }
    
}

