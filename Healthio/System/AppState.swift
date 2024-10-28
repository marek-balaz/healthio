//
//  AppState.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import SwiftUI

struct AppState: Equatable {
    
    var routerOverview: [RouteOverview] = []
    
    var routerSettings: [RouteSettings] = []
    
    var userData: UserData = UserData()
    
    var system: System
    
}

extension AppState {
    
    static var preview = AppState(
        system: .init(
            locale: .init(identifier: UserDefaults.standard.userLocale ?? ""),
            theme: .init(rawValue: UserDefaults.standard.userTheme)
        )
    )

}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.userData == rhs.userData &&
        lhs.routerOverview == rhs.routerOverview &&
        lhs.routerSettings == rhs.routerSettings &&
        lhs.system == rhs.system
}

struct System: Equatable {
    
    var locale: Locale? {
        didSet {
            UserDefaults.standard.userLocale = locale?.identifier
        }
    }
    
    var theme: Theme? {
        didSet {
            UserDefaults.standard.userTheme = theme?.rawValue ?? Theme.system.rawValue
        }
    }
    
    var isActive: Bool = false
    
    var keyboardHeight: CGFloat = 0
    
}

struct UserData: Equatable {
    
    var userProfile: Loadable<UserProfile?> = .notRequested {
        didSet {
            switch userProfile {
            case .notRequested, .failed, .isLoading:
                break
            case .loaded(let profile):
                if let profile {
                    UserDefaults.standard.userSelectedProfileId = profile.id.uuidString
                }
            }
        }
    }

}
