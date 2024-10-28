//
//  BloodPressureCategory.swift
//  Healthio
//
//  Created by Marek Baláž on 28/10/2024.
//

import Foundation
import SwiftUI

enum BloodPressureCategory {
    case normal
    case elevated
    case highBloodPressureStage1
    case highBloodPressureStage2
    case hypertensiveCrisis
    case unknown // In case the values are invalid
    
    var description: LocalizedStringResource {
        switch self {
        case .normal:
            return "blood_pressure_normal"
        case .elevated:
            return "blood_pressure_elevated"
        case .highBloodPressureStage1:
            return "blood_pressure_stage_1"
        case .highBloodPressureStage2:
            return "blood_pressure_stage_2"
        case .hypertensiveCrisis:
            return "blood_pressure_crisis"
        case .unknown:
            return "blood_pressure_unknown"
        }
    }
    
    var color: Color {
        switch self {
        case .highBloodPressureStage1:
            return .orange
        case .highBloodPressureStage2:
            return .yellow
        case .hypertensiveCrisis:
            return .purple
        case .unknown:
            return .gray
        default:
            return .red
        }
    }
    
}
