//
//  BloodPressureService.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import Combine

protocol BloodPressureService {
    
    func addRecord(_ bloodPressure: BloodPressure) -> AnyPublisher<Void, Error>
    
    func editRecord(_ bloodPressure: BloodPressure) -> AnyPublisher<Void, Error>
    
    func deleteRecord(_ bloodPressure: BloodPressure) -> AnyPublisher<Void, Error>
    
    func fetchRecords() -> AnyPublisher<[BloodPressure], Error>
    
    func bloodPressureCategory(systolic: Int, diastolic: Int) -> BloodPressureCategory
}

struct BloodPressureServiceImpl: BloodPressureService {
    
    let appState: Store<AppState>
    
    let bloodPressureRepository: BloodPressureDBRepository
    
    init(
        appState: Store<AppState>,
        bloodPressureRepository: BloodPressureDBRepository
    ) {
        self.appState = appState
        self.bloodPressureRepository = bloodPressureRepository
    }
    
    func addRecord(_ bloodPressure: BloodPressure) -> AnyPublisher<Void, Error> {
        return bloodPressureRepository.add(bloodPressure: bloodPressure)
    }
    
    func editRecord(_ bloodPressure: BloodPressure) -> AnyPublisher<Void, Error> {
        return bloodPressureRepository.edit(bloodPressure: bloodPressure)
    }
    
    func deleteRecord(_ bloodPressure: BloodPressure) -> AnyPublisher<Void, Error> {
        return bloodPressureRepository.delete(bloodPressure: bloodPressure)
    }
    
    func fetchRecords() -> AnyPublisher<[BloodPressure], Error> {
        if let userId = appState[\.userData.userProfile].value??.id {
            return bloodPressureRepository.fetchAll(userId)
        } else {
            return Future { promise in
                promise(.success([]))
            }
            .eraseToAnyPublisher()
        }
    }
    
    func bloodPressureCategory(systolic: Int, diastolic: Int) -> BloodPressureCategory {
        switch (systolic, diastolic) {
        case (let s, let d) where s < 120 && d < 80:
            return .normal
        case (let s, let d) where s >= 120 && s < 130 && d < 80:
            return .elevated
        case (let s, let d) where (s >= 130 && s < 140) || (d >= 80 && d < 90):
            return .highBloodPressureStage1
        case (let s, let d) where s >= 140 || d >= 90:
            return .highBloodPressureStage2
        case (let s, let d) where s > 180 && d > 120:
            return .hypertensiveCrisis
        default:
            return .unknown
        }
    }
    
}
