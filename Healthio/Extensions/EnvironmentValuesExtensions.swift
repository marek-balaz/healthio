//
//  EnviromentValuesExtensions.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import SwiftUI

private extension Array where Element == Locale {
    func locale(withId identifier: String) -> Element? {
        first(where: { $0.identifier.hasPrefix(identifier) })
    }
}

extension EnvironmentValues {
    
    static var supportedLocales: [Locale] = {
        let bundle = Bundle.main
        return bundle.localizations.map { Locale(identifier: $0) }
    }()
    
    static var currentLocale: Locale? {
        let current = Locale.current
        let fullId = current.identifier
        let shortId = String(fullId.prefix(2))
        return supportedLocales.locale(withId: fullId) ??
        supportedLocales.locale(withId: shortId)
    }
    
}


