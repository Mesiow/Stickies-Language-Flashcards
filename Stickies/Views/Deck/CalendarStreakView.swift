//
//  StickyNoteCalendarView.swift
//  Stickies
//
//  Created by Chris W on 12/13/25.
//

import SwiftUI

struct CalendarStreakView: View {
    @Environment(\.dismiss) private var dismiss
    
    let studyDates: [Date]  // days user studied this month
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    private var monthDays: [Date] {
        Calendar.current.generateDaysForCurrentMonth()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 12) {
                    // Month title
                    Text(Date().formatted(.dateTime.month(.wide).year()))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.black.opacity(0.8))
                    
                    // Sticky Note Background
                    VStack(spacing: 12) {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(monthDays, id: \.self) { day in
                                
                                let studied = Calendar.current.isDateInDates(day, studyDates)
                                let isToday = Calendar.current.isDateInToday(day)
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(studied ? AppInfo.stickyNoteTintColor : AppInfo.backgroundColor)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(isToday ? Color.black.opacity(0.3) : .clear, lineWidth: 2)
                                        )
                                    
                                    VStack(spacing: 6) {
                                        Text("\(Calendar.current.component(.day, from: day))")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(.black.opacity(studied ? 1 : 0.45))
                                        
                                        Image(systemName: SFSymbols.checkmarkCircleFill)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(studied ? .green : .gray)
                                    }
                                    .padding(4)
                                }
                                .frame(height: 44)
                            }
                        }
                    }
                    .padding()
                    .background(
                        AppInfo.stickyNoteTintColor.opacity(0.70)
                    )
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(style: StrokeStyle(lineWidth: 1.6, lineCap: .round, dash: [4, 4]))
                    )
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                      dismiss()
                    }label: {
                        Image(systemName: SFSymbols.xmark)
                            .foregroundStyle(AppInfo.actionButtonTintColor)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

extension Calendar {
    func generateDaysForCurrentMonth() -> [Date] {
        let today = Date()
        guard
            let monthInterval = dateInterval(of: .month, for: today),
            let monthEnd = date(byAdding: .day, value: -1, to: monthInterval.end)
        else { return [] }
        
        return dates(from: monthInterval.start, to: monthEnd)
    }
    
    func dates(from start: Date, to end: Date) -> [Date] {
        var dates: [Date] = []
        var current = start
        
        while current <= end {
            dates.append(current)
            current = date(byAdding: .day, value: 1, to: current)!
        }
        return dates
    }
    
    func isDateInDates(_ date: Date, _ dates: [Date]) -> Bool {
        dates.contains { isDate($0, inSameDayAs: date) }
    }
}


