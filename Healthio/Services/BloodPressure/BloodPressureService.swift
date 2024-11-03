//
//  BloodPressureService.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import Combine

protocol BloodPressureService {
    
    func store(bloodPressureRecords: [BloodPressure], for userProfileId: UUID) -> AnyPublisher<Void, Error>
    
    func edit(bloodPressure: BloodPressure) -> AnyPublisher<Void, Error>
    
    func delete(bloodPressureId: UUID) -> AnyPublisher<Void, Error>
    
    func fetch(interval: Interval, for userProfileId: UUID) -> AnyPublisher<[BloodPressure], Error>
    
    func bloodPressureCategory(systolic: Int, diastolic: Int) -> BloodPressureCategory
    
}

struct BloodPressureServiceImpl: BloodPressureService {

    let appState: Store<AppState>
    
    let usersRepository: UsersDBRepository
    
    let bloodPressureRepository: BloodPressureDBRepository
    
    init(
        appState: Store<AppState>,
        usersRepository: UsersDBRepository,
        bloodPressureRepository: BloodPressureDBRepository
    ) {
        self.appState = appState
        self.usersRepository = usersRepository
        self.bloodPressureRepository = bloodPressureRepository
    }
    
    func store(
        bloodPressureRecords: [BloodPressure],
        for userProfileId: UUID
    ) -> AnyPublisher<Void, Error> {
        bloodPressureRepository.store(
            bloodPressureRecords: bloodPressureRecords,
            for: userProfileId
        )
    }
    
    func edit(
        bloodPressure: BloodPressure
    ) -> AnyPublisher<Void, Error> {
        bloodPressureRepository.edit(
            bloodPressure: bloodPressure
        )
    }
    
    func delete(
        bloodPressureId: UUID
    ) -> AnyPublisher<Void, Error> {
        bloodPressureRepository.delete(
            bloodPressureId: bloodPressureId
        )
    }
    
    func fetch(
        interval: Interval,
        for userProfileId: UUID
    ) -> AnyPublisher<[BloodPressure], Error> {
        bloodPressureRepository.fetch(
            interval: interval,
            for: userProfileId
        )
    }
    
    func bloodPressureCategory(
        systolic: Int,
        diastolic: Int
    ) -> BloodPressureCategory {
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
