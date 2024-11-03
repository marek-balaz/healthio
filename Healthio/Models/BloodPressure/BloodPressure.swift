//
//  BloodPressure.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import CoreData

struct BloodPressure: Equatable, Hashable {
    
    let bpId: UUID
    
    let userId: UUID
    
    let diastolic: Int
    
    let systolic: Int
    
    let pulse: Int
    
    let timestamp: Date
    
    init(bpId: UUID, userId: UUID, diastolic: Int, systolic: Int, pulse: Int, timestamp: Date) {
        self.bpId = bpId
        self.userId = userId
        self.diastolic = diastolic
        self.systolic = systolic
        self.pulse = pulse
        self.timestamp = timestamp
    }
    
}

extension BloodPressure {
    var id: UUID { bpId }
}

extension BloodPressureMO: ManagedEntity { }

extension BloodPressure {
    
    init?(managedObject: BloodPressureMO) {
        guard
            let bpId = managedObject.bpId,
            let userId = managedObject.user?.userId,
            let timestamp = managedObject.timestamp
        else {
            return nil
        }
        
        self.init(
            bpId: bpId,
            userId: userId,
            diastolic: Int(managedObject.diastolic),
            systolic: Int(managedObject.systolic),
            pulse: Int(managedObject.pulse),
            timestamp: timestamp
        )
    }
    
    @discardableResult
    func store(in context: NSManagedObjectContext,
               user: UserProfileMO
    ) -> BloodPressureMO? {
        guard let bloodPressure = BloodPressureMO.insertNew(in: context)
            else { return nil }
        bloodPressure.bpId = bpId
        bloodPressure.user = user
        bloodPressure.diastolic = Int32(diastolic)
        bloodPressure.systolic = Int32(systolic)
        bloodPressure.pulse = Int32(pulse)
        bloodPressure.timestamp = timestamp
        return bloodPressure
    }
    
}

extension BloodPressure {
    
    static let mockStefan: [BloodPressure] = [
        // Stefan's Data
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046e1")!, userId: UserProfile.stefanId, diastolic: 88, systolic: 134, pulse: 87, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "18.04.2024 07:45")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046e2")!, userId: UserProfile.stefanId, diastolic: 89, systolic: 144, pulse: 88, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "18.04.2024 18:22")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046e3")!, userId: UserProfile.stefanId, diastolic: 87, systolic: 138, pulse: 92, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "19.04.2024 08:01")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046e4")!, userId: UserProfile.stefanId, diastolic: 95, systolic: 149, pulse: 89, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "19.04.2024 16:40")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046e5")!, userId: UserProfile.stefanId, diastolic: 92, systolic: 132, pulse: 91, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "20.04.2024 08:24")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046e6")!, userId: UserProfile.stefanId, diastolic: 96, systolic: 151, pulse: 93, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "20.04.2024 17:15")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046e7")!, userId: UserProfile.stefanId, diastolic: 94, systolic: 142, pulse: 88, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "21.04.2024 07:55")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046e8")!, userId: UserProfile.stefanId, diastolic: 97, systolic: 168, pulse: 87, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "21.04.2024 18:16")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046e9")!, userId: UserProfile.stefanId, diastolic: 102, systolic: 154, pulse: 92, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "22.04.2024 07:48")!),
    ]
    
    static let mockElena: [BloodPressure] = [
        // Elena's Data
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046f1")!, userId: UserProfile.elenaId, diastolic: 80, systolic: 112, pulse: 67, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "18.04.2024 07:25")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046f2")!, userId: UserProfile.elenaId, diastolic: 79, systolic: 110, pulse: 68, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "18.04.2024 19:44")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046f3")!, userId: UserProfile.elenaId, diastolic: 78, systolic: 98, pulse: 64, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "19.04.2024 08:28")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046f4")!, userId: UserProfile.elenaId, diastolic: 82, systolic: 110, pulse: 63, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "19.04.2024 17:14")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046f5")!, userId: UserProfile.elenaId, diastolic: 83, systolic: 112, pulse: 64, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "20.04.2024 08:11")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046f6")!, userId: UserProfile.elenaId, diastolic: 95, systolic: 160, pulse: 85, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "20.04.2024 17:35")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046f7")!, userId: UserProfile.elenaId, diastolic: 82, systolic: 113, pulse: 62, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "21.04.2024 07:49")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046f8")!, userId: UserProfile.elenaId, diastolic: 81, systolic: 122, pulse: 64, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "21.04.2024 17:47")!),
        BloodPressure(bpId: UUID(uuidString: "5b87b2f3-0235-4e76-b904-d62459f046f9")!, userId: UserProfile.elenaId, diastolic: 84, systolic: 121, pulse: 71, timestamp: DateFormatter.dd_MM_yyyy_HH_mm.date(from: "22.04.2024 08:38")!)
    ]
    
}
