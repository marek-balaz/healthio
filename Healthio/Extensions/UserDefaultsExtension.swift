//
//  UserDefaultsExtension.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import SwiftUI

extension UserDefaults {
    
    public struct C {
        static let userLocaleKey = "user_locale"
        static let userThemeKey = "user_theme"
        static let userSelectedProfileIdKey = "user_selected_user_id"
        static let mockDataKey = "mock_data"
    }
    
    @objc var userLocale: String? {
        get { string(forKey: C.userLocaleKey) }
        set { setValue(newValue, forKey: C.userLocaleKey) }
    }
    
    @objc var userTheme: String {
        get { string(forKey: C.userThemeKey) ?? "" }
        set { setValue(newValue, forKey: C.userThemeKey) }
    }
    
    @objc var userSelectedProfileId: String? {
        get { string(forKey: C.userSelectedProfileIdKey) }
        set { setValue(newValue, forKey: C.userSelectedProfileIdKey) }
    }
    
    @objc var mockDataLoaded: Bool {
        get { bool(forKey: C.mockDataKey) }
        set { setValue(newValue, forKey: C.mockDataKey) }
    }
}
    
