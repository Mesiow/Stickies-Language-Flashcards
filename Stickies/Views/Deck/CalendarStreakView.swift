//
//  StickyNoteCalendarView.swift
//  Stickies
//
//  Created by Chris W on 12/13/25.
//
import SwiftUI
import SwiftData

struct CalendarStreakView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentMonth: Date = Date()
    @Query(sort: \StudyDay.date) private var studiedDays: [StudyDay]
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var daysInMonth: [Date] {
        Calendar.current.generateDaysForMonth(currentMonth)
    }
    
    var streakCount: Int {
        StudyTrackingManager.shared.currentStreak(from: studiedDays)
    }
    
    var mascotImage: String {
        switch streakCount {
        case 0: return AppInfo.sadCharacter
        case 1...3: return AppInfo.happyCharacter
        case 4...10: return AppInfo.stokedCharacter
        default: return AppInfo.stokedCharacter
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 22) {
                
                /*Spacer()
                    .frame(height: 100)*/
                
                StickyMascotView(
                       width: 90,
                       height: 90,
                       image: mascotImage,
                       message: nil
                   )
                   .transition(.scale.combined(with: .opacity))
                
                // MARK: - Header
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Text("\(streakCount)")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundStyle(AppInfo.mainTintColor)
                        
                        Text("day streak")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(.black.opacity(0.85))
                    }
                    
                    Text("Review your flashcards daily to keep your streak going!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.black.opacity(0.75))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                
                // MARK: - Month Controls
                HStack(alignment: .center, spacing: 20) {
                    Text(currentMonth.formatted(.dateTime.month(.wide).year()))
                        .font(.system(size: 20, weight: .semibold))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button { changeMonth(-1) }
                    label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black.opacity(0.6))
                    }
                    
                    Button { changeMonth(+1) }
                    label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.black.opacity(0.6))
                    }
                }
                .padding(.horizontal)
                
                //MARK: - Days of Week
                  HStack(spacing: 0) {
                      ForEach(Array(["M", "T", "W", "T", "F", "S", "S"].enumerated()), id: \.offset) { _, day in
                          Text(day)
                              .font(.system(size: 14, weight: .medium))
                              .foregroundStyle(.black.opacity(0.6))
                              .frame(maxWidth: .infinity)
                      }
                  }
                  .padding(.horizontal, 8)
                
                //MARK: - Calendar Grid
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(daysInMonth, id: \.self) { day in
                        DayTile(
                            date: day,
                            studied: Calendar.current.containsDay(day, in: studiedDays),
                            isToday: Calendar.current.isDateInToday(day)
                        )
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: currentMonth)
                .padding(.horizontal)
                
                // MARK: - Optional Freeze Message
               /* HStack {
                    Image(systemName: "snowflake")
                        .foregroundStyle(.blue)
                    Text("1 Streak Freeze left")
                        .font(.system(size: 15, weight: .semibold))
                    Spacer()
                }
                .padding()
                .background(Color.blue.opacity(0.12))
                .cornerRadius(14)
                .padding(.horizontal)*/
                
                Spacer()
            }
            .background(AppInfo.backgroundColor.ignoresSafeArea())
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                      dismiss()
                    }label: {
                        Image(systemName: SFSymbols.xmark)
                            .foregroundStyle(AppInfo.mainTintColor)
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func changeMonth(_ offset: Int) {
        if let updated = Calendar.current.date(byAdding: .month, value: offset, to: currentMonth) {
            currentMonth = updated
        }
    }
}

struct DayTile: View {
    let date: Date
    let studied: Bool
    let isToday: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(isToday ? AppInfo.stickyNoteTintColor : tileBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isToday ? AppInfo.actionButtonTintColor : .clear, lineWidth: 2)
                )
                .frame(height: 48)
            
            VStack(spacing: 2) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.black.opacity(studied ? 1 : 0.4))
                
                if studied {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.orange)
                }
            }
        }
    }
    
    private var tileBackground: Color {
        studied
        ? AppInfo.stickyNoteTintColor
        : Color.black.opacity(0.08)
    }
}

