//
//  UserProfile.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import CoreData
import UIKit

struct UserProfile: Equatable, Hashable {

    let userId: UUID
    
    let name: String
    
    let avatar: Data?
    
    let birthDate: Date
    
    let weight: Double
    
    let height: Double
    
}

// Prototype mocks
extension UserProfile {
    static let stefanId: UUID = UUID(uuidString: "00000000-0000-0000-1000-000000000000")!
    static let elenaId: UUID = UUID(uuidString: "00000000-0000-0000-2000-000000000001")!
    
    static let mockProfile: UserProfile = .init(
        userId: UUID(),
        name: "Rastislav",
        avatar: UIImage(named: "male-face")?.pngData(),
        birthDate: DateFormatter.dd_MM_yyyy.date(from: "20.12.1970")!,
        weight: 120.8,
        height: 180
    )
}

extension UserProfile: Identifiable {
    var id: UUID { userId }
}

extension UserProfileMO: ManagedEntity { }

extension UserProfile {
    
    init?(managedObject: UserProfileMO) {
        guard
            let id = managedObject.userId,
            let name = managedObject.name,
            let birthDate = managedObject.birthDate
        else {
            return nil
        }
        
        self.init(
            userId: id,
            name: name,
            avatar: managedObject.avatar,
            birthDate: birthDate,
            weight: managedObject.weight,
            height: managedObject.height
        )
    }
    
    @discardableResult
    func store(in context: NSManagedObjectContext) -> UserProfileMO? {
        guard let userProfile = UserProfileMO.insertNew(in: context)
            else { return nil }
        userProfile.userId = userId
        userProfile.name = name
        userProfile.avatar = avatar
        userProfile.birthDate = birthDate
        userProfile.weight = weight
        userProfile.height = height
        return userProfile
    }
    
}
