//
//  Calendar+Ext.swift
//  Stickies
//
//  Created by Chris W on 12/13/25.
//

import SwiftUI

extension Calendar {
    func generateDaysForMonth(_ date: Date) -> [Date] {
        guard
            let monthInterval = dateInterval(of: .month, for: date),
            let end = self.date(byAdding: .day, value: -1, to: monthInterval.end)
        else { return [] }
        
        return dates(from: monthInterval.start, to: end)
    }
    
    func dates(from start: Date, to end: Date) -> [Date] {
        var result: [Date] = []
        var current = start
        
        while current <= end {
            result.append(current)
            current = self.date(byAdding: .day, value: 1, to: current)!
        }
        return result
    }
    
    func containsDay(_ date: Date, in days: [StudyDay]) -> Bool {
        days.contains {
            isDate($0.date ?? Date(), inSameDayAs: date)
        }
    }
}

