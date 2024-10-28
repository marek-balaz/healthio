//
//  DIContainer.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import SwiftUI
import SwiftData

struct DIContainer: EnvironmentKey {
    
    let appState: Store<AppState>
    let services: Services
    let repositories: Repositories
    
    init(appState: Store<AppState>, services: Services, repositories: Repositories) {
        self.appState = appState
        self.services = services
        self.repositories = repositories
    }
    
    init(appState: AppState, services: Services, repositories: Repositories) {
        self.init(appState: Store<AppState>(appState), services: services, repositories: repositories)
    }
    
    static var defaultValue: Self {
        Self.default
    }
    
    private static let `default` = Self(
        appState: .preview,
        services: .stub,
        repositories: .stub
    )
}

extension EnvironmentValues {
    
    var di: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}

extension DIContainer {
    
    struct Services {
        
        let usersService: UsersService
        let bloodPressureService: BloodPressureService
        
        static let stub = Self(
            usersService: StubUsersService(),
            bloodPressureService: StubBloodPressureService()
        )
    }
    
    struct Repositories {
        
        let usersRepository: UsersDBRepository
        let bloodPressureRepository: BloodPressureDBRepository
        
        static let stub = Self(
           usersRepository: StubUsersDBRepository(),
           bloodPressureRepository: StubBloodPressureDBRepository()
        )
    }
    
    static let preview = Self(
        appState: .preview,
        services: .stub,
        repositories: .stub
    )
}
