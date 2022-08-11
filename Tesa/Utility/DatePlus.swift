//
//  DatePlus.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-29.
//

import Foundation

extension Date {
    /// Create Date instance with timestamp format "yyyy/MM/dd HH:mm"
    public static func getDate(at timestamp: String) -> Date {
        return getDate(at: timestamp, format: "yyyy/MM/dd HH:mm")
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        return formatter.date(from: timestamp) ?? Date()
    }
    
    public static func getDate(at timestamp: String, format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: timestamp) ?? Date()
    }
    
    func getComponent(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
