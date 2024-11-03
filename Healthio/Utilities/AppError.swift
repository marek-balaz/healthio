//
//  AppError.swift
//  Healthio
//
//  Created by Marek Baláž on 31/10/2024.
//

import Foundation

enum AppError: Error {
    
    case domain(Domain)
    
    enum Domain {
        case presentation(Presentation)
        case business(Business)
        case data(Data)
        
        enum Presentation: Error, LocalizedError {
            
        }
        
        enum Business: Error, LocalizedError {
            
        }
        
        enum Data: Error, LocalizedError {
            
            case unexpectedError
            case notFound
            
            public var errorDescription: String? {
                switch self {
                case .unexpectedError:
                    return String(localized: "global_repo_error")
                case .notFound:
                    return String(localized: "global_repo_not_found")
                }
            }
        }
    }
    
}
