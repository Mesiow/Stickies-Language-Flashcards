//
//  StudyTrackingManager.swift
//  Stickies
//
//  Created by Chris W on 12/14/25.
//

import SwiftUI
import SwiftData

final class StudyTrackingManager {
    static let shared = StudyTrackingManager()
    private init() {}
    
    func recordStudyDay(context: ModelContext) {
        let today = Calendar.current.startOfDay(for: Date())

        let descriptor = FetchDescriptor<StudyDay>(
            predicate: #Predicate { $0.date == today }
        )

        let exists = (try? context.fetch(descriptor))?.isEmpty == false

        //If day record doesn't already exist, add it
        if !exists {
            context.insert(StudyDay(date: today))
        }
    }

    func currentStreak(from studyDays: [StudyDay]) -> Int {
        let calendar = Calendar.current
        
        let uniqueDays = Set(
            studyDays.map { calendar.startOfDay(for: $0.date ?? Date()) }
        )
        
        var streak = 0
        var currentDay = calendar.startOfDay(for: Date())
        
        // Allow streak to continue if last study was yesterday
        if !uniqueDays.contains(currentDay) {
            currentDay = calendar.date(byAdding: .day, value: -1, to: currentDay)!
        }
        
        while uniqueDays.contains(currentDay) {
            streak += 1
            currentDay = calendar.date(byAdding: .day, value: -1, to: currentDay) ?? Date()
        }
        
        return streak
    }
    
}

