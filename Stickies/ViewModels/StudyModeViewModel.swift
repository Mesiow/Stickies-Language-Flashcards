//
//  StudyModeViewModel.swift
//  Stickies
//
//  Created by Chris W on 11/17/25.
//

import SwiftUI
import Combine

final class StudyModeViewModel: ObservableObject {
    @Published var showEndStudyModeConfirmation = false
    @Published var showResults = false
    @Published var correctCount = 0
    @Published var incorrectCount = 0
    
    //Strength Decay SRS (Spaced Repetition System) Methods
    
}
