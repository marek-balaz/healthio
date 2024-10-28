//
//  Route.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation
import UIKit

enum RouteOverview: Equatable, Hashable {
    
    case userProfileDetail
    
}

enum RouteSettings: Equatable, Hashable {
    
    
}

struct ClosureWrapper<T>: Equatable, Hashable {
    
    let id: UUID
    
    let callback: (T) -> Void
    
    init(callback: @escaping (T) -> Void) {
        self.id = UUID()
        self.callback = callback
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
    
    static func == (lhs: ClosureWrapper<T>, rhs: ClosureWrapper<T>) -> Bool {
        lhs.id == rhs.id
    }
}

struct ClosureWrapper2: Equatable, Hashable {
    
    let id: UUID
    
    let callback: () -> Void
    
    init(callback: @escaping () -> Void) {
        self.id = UUID()
        self.callback = callback
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
    
    static func == (lhs: ClosureWrapper2, rhs: ClosureWrapper2) -> Bool {
        lhs.id == rhs.id
    }
}
