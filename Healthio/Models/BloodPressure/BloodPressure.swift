//
//  BloodPressure.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import CoreData

struct BloodPressure: Equatable, Hashable, Identifiable {

    let id: UUID = UUID()
    
    let userId: UUID
    
    let diastolic: Int
    
    let systolic: Int
    
    let pulse: Int
    
    let timestamp: Date
    
}

extension BloodPressure {
    
    static let mockStefan: [BloodPressure] = [
        // Stefan's Data
        BloodPressure(userId: UserProfile.stefanId, diastolic: 88, systolic: 134, pulse: 87, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "18.04.2022 07:45")!),
        BloodPressure(userId: UserProfile.stefanId, diastolic: 89, systolic: 144, pulse: 88, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "18.04.2022 18:22")!),
        BloodPressure(userId: UserProfile.stefanId, diastolic: 87, systolic: 138, pulse: 92, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "19.04.2022 08:01")!),
        BloodPressure(userId: UserProfile.stefanId, diastolic: 95, systolic: 149, pulse: 89, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "19.04.2022 16:40")!),
        BloodPressure(userId: UserProfile.stefanId, diastolic: 92, systolic: 132, pulse: 91, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "20.04.2022 08:24")!),
        BloodPressure(userId: UserProfile.stefanId, diastolic: 96, systolic: 151, pulse: 93, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "20.04.2022 17:15")!),
        BloodPressure(userId: UserProfile.stefanId, diastolic: 94, systolic: 142, pulse: 88, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "21.04.2022 07:55")!),
        BloodPressure(userId: UserProfile.stefanId, diastolic: 97, systolic: 168, pulse: 87, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "21.04.2022 18:16")!),
        BloodPressure(userId: UserProfile.stefanId, diastolic: 102, systolic: 154, pulse: 92, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "22.04.2022 07:48")!),
    ]
    
    static let mockElena: [BloodPressure] = [
        // Elena's Data
        BloodPressure(userId: UserProfile.elenaId, diastolic: 80, systolic: 112, pulse: 67, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "18.04.2022 07:25")!),
        BloodPressure(userId: UserProfile.elenaId, diastolic: 79, systolic: 110, pulse: 68, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "18.04.2022 19:44")!),
        BloodPressure(userId: UserProfile.elenaId, diastolic: 78, systolic: 98, pulse: 64, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "19.04.2022 08:28")!),
        BloodPressure(userId: UserProfile.elenaId, diastolic: 82, systolic: 110, pulse: 63, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "19.04.2022 17:14")!),
        BloodPressure(userId: UserProfile.elenaId, diastolic: 83, systolic: 112, pulse: 64, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "20.04.2022 08:11")!),
        BloodPressure(userId: UserProfile.elenaId, diastolic: 95, systolic: 160, pulse: 85, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "20.04.2022 17:35")!),
        BloodPressure(userId: UserProfile.elenaId, diastolic: 82, systolic: 113, pulse: 62, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "21.04.2022 07:49")!),
        BloodPressure(userId: UserProfile.elenaId, diastolic: 81, systolic: 122, pulse: 64, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "21.04.2022 17:47")!),
        BloodPressure(userId: UserProfile.elenaId, diastolic: 84, systolic: 121, pulse: 71, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "22.04.2022 08:38")!)
    ]
    
}

extension BloodPressureMO: ManagedEntity { }

extension BloodPressure {
    
    init?(managedObject: BloodPressureMO) {
        guard
            let id = managedObject.userId,
            let timestamp = managedObject.timestamp
        else {
            return nil
        }
        
        self.init(
            userId: id,
            diastolic: Int(managedObject.diastolic),
            systolic: Int(managedObject.systolic),
            pulse: Int(managedObject.pulse),
            timestamp: timestamp
        )
    }
    
    @discardableResult
    func store(in context: NSManagedObjectContext) -> BloodPressureMO? {
        guard let bloodPressure = BloodPressureMO.insertNew(in: context)
            else { return nil }
        bloodPressure.userId = userId
        bloodPressure.diastolic = Int32(diastolic)
        bloodPressure.systolic = Int32(systolic)
        bloodPressure.pulse = Int32(pulse)
        bloodPressure.timestamp = timestamp
        return bloodPressure
    }
    
}
