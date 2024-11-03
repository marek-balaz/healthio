//
//  AppEnvironment.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation

struct AppEnvironment {
    
    let container: DIContainer
    
}

extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        
        let appState = Store<AppState>(
            AppState(
                system: .init(
                    locale: .init(identifier: UserDefaults.standard.userLocale ?? ""),
                    theme: .init(rawValue: UserDefaults.standard.userTheme)
                )
            )
        )
        
        let repositories = dbRepositories(appState: appState)
        
        return AppEnvironment(
            container: .init(
                
                appState: appState,
                
                services: services(appState: appState, dbRepositories: repositories),
                
                repositories: repositories
            )
        )
    }
    
    private static func services(
        appState: Store<AppState>,
        dbRepositories: DIContainer.Repositories
    ) -> DIContainer.Services {
        
        let usersService = UsersServiceImpl(
            appState: appState,
            usersRepository: dbRepositories.usersRepository
        )
        
        let bloodPressureService = BloodPressureServiceImpl(
            appState: appState,
            usersRepository: dbRepositories.usersRepository,
            bloodPressureRepository: dbRepositories.bloodPressureRepository
        )
        
        return .init(
            usersService: usersService,
            bloodPressureService: bloodPressureService
        )
    }
    
    private static func dbRepositories(
        appState: Store<AppState>
    ) -> DIContainer.Repositories {
        
        let persistentStore = CoreDataStack(version: CoreDataStack.Version.actual)
        
        let usersDBRepository = UsersDBRepositoryImpl(persistentStore: persistentStore)
        
        let bloodPressureDBRepository = BloodPressureDBRepositoryImpl(persistentStore: persistentStore)
        
        return .init(
            usersRepository: usersDBRepository,
            bloodPressureRepository: bloodPressureDBRepository
        )
    }

}
