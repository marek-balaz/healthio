//
//  HealthioApp.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import SwiftUI
import SwiftData
import Combine

@main
struct HealthioApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @Environment(\.locale) private var defaultLocale: Locale
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.di) private var di
    
    @State private var locale: Locale?
    
    @State private var theme: Theme?
    
    @State private var cancelBag: CancelBag = .init()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                OverviewRootView {
                    OverviewScreen()
                }
                .tabItem {
                    Label(LocalizedStringKey("title_overview"), systemImage: "cross")
                }
                
                SettingsRootView {
                    SettingsScreen()
                }
                .tabItem {
                    Label(LocalizedStringKey("title_settings"), systemImage: "gearshape")
                }
            }
            .onAppear {
                // Prototype
                if UserDefaults.standard.mockDataLoaded {
                    delegate.appEnvironment.container.services.usersService.getSelectedUser(id: nil)
                } else {
                    preparePrototype()
                }
            }
            .onReceive(localeUpdate) { locale in
                if let locale = locale {
                    self.locale = locale
                }
            }
            .onReceive(colorSchemeUpdate) { theme in
                self.theme = theme
            }
            .preferredColorScheme(currentColorScheme)
            .environment(\.locale, currentLocale)
            .environment(\.di, delegate.appEnvironment.container)
        }
        
    }

}

extension HealthioApp {
    var localeUpdate: AnyPublisher<Locale?, Never> {
        di.appState.updates(for: \.system.locale)
    }
    
    var localeBinding: Binding<Locale?> {
        $locale.dispatched(to: di.appState, \.system.locale)
    }
    
    var currentLocale: Locale {
        if locale?.identifier.isEmpty == false {
            return locale ?? defaultLocale
        }
        
        if di.appState[\.system].locale?.identifier.isEmpty == false {
            return di.appState[\.system].locale ?? defaultLocale
        }
        
        return defaultLocale
    }
}

extension HealthioApp {
    var colorSchemeUpdate: AnyPublisher<Theme?, Never> {
        delegate.appEnvironment.container.appState.updates(for: \.system.theme)
    }
    
    var colorSchemeBinding: Binding<Theme?> {
        $theme.dispatched(to: delegate.appEnvironment.container.appState, \.system.theme)
    }
    
    var currentColorScheme: ColorScheme? {
        theme?.colorScheme ?? di.appState[\.system].theme?.colorScheme
    }
}

// MARK: Prototype only
extension HealthioApp {
    
    func preparePrototype() {
        let addUserStefan = delegate.appEnvironment.container.services.usersService.addUser(
            .init(
                userId: UserProfile.stefanId,
                name: "Štefan",
                avatar: UIImage(named: "male-face")?.pngData(),
                birthDate: DateFormatter.dd_MM_yyyy.date(from: "20.12.1970")!,
                weight: 120.8,
                height: 180
            )
        )

        let addUserElena = delegate.appEnvironment.container.services.usersService.addUser(
            .init(
                userId: UserProfile.elenaId,
                name: "Elena",
                avatar: UIImage(named: "woman-face")?.pngData(),
                birthDate: DateFormatter.dd_MM_yyyy.date(from: "20.12.2000")!,
                weight: 52.5,
                height: 172
            )
        )

        let addBloodPressureRecordsElena = delegate.appEnvironment.container.services.bloodPressureService.store(bloodPressureRecords: BloodPressure.mockElena, for: UserProfile.elenaId)
        let addBloodPressureRecordsStefan = delegate.appEnvironment.container.services.bloodPressureService.store(bloodPressureRecords: BloodPressure.mockStefan, for: UserProfile.stefanId)

        let allPublishers = [addUserStefan, addUserElena, addBloodPressureRecordsElena, addBloodPressureRecordsStefan]

        allPublishers.publisher
            .flatMap { $0 }
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    UserDefaults.standard.mockDataLoaded = true
                    delegate.appEnvironment.container.services.usersService.getSelectedUser(id: nil)
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }, receiveValue: { _ in
                // skip
            })
            .store(in: cancelBag)
    }
    
}

