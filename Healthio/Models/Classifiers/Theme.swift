//
//  AppearanceType.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import SwiftUI
import UIKit

enum Theme: String, CaseIterable, Equatable, Hashable {
    
    case system = "system"
    case dark = "dark"
    case light = "light"
    
    init(rawValue: String) {
        switch rawValue {
        case "dark":
            self = .dark
        case "light":
            self = .light
        default:
            self = .system
        }
    }
    
    var name: LocalizedStringResource {
        switch self {
        case .dark:
            return "theme_dark"
        case .light:
            return "theme_light"
        default:
            return "theme_system"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .dark:
            return .dark
        case .light:
            return .light
        default:
            return nil
        }
    }
    
}
