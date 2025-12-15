//
//  StudyDay.swift
//  Stickies
//
//  Created by Chris W on 12/14/25.
//

import SwiftUI
import SwiftData

//Model for keeping track of the dates that the user reviewed
@Model
final class StudyDay: Identifiable, Hashable {
    var date: Date?
    
    init(date: Date) {
        self.date = date
    }
}

