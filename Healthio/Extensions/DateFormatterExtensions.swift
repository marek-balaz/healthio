//
//  DateFormatterExtensions.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import Foundation

extension DateFormatter {
    static let dd_MM_yyyy_HH_mm: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter
    }()
    
    static let dd_MM_yyyy: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
}

