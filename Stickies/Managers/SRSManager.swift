//
//  SRSManager.swift
//  Stickies
//
//  Created by Chris W on 11/26/25.
//

import SwiftUI

enum StrengthLevel: Int {
    case none, weak, moderate, strong
    
    var barColor: Color {
        switch self {
        case .weak: return Color.red
        case .moderate: return Color.orange
        case .strong: return Color.green
        default: return Color.clear
        }
    }
    
    var dailyDecayRate: Double {
        switch self {
        case .weak: 0.10 //10%  per day
        case .moderate: 0.05 //5%
        case .strong: 0.02 //2%
        case .none: 0.08
        }
    }
    
    //Rate used for when the user gets a card incorrect/forgets a card
    var penaltyDecayRate: Double {
        switch self {
        case .weak, .moderate: 0.25 //-25%
        case .strong: 0.15 //-15%, less penalty if card is already strong
        case .none: 0.25
        }
    }
    
    static var strengthRate: Double = 0.15 //+15% for when correct answer
}

//Strength Decay based SRS (Spaced Repetition System) Manager
final class SRSManager {
    static let shared = SRSManager()
    private init() { }
    
    // MARK: - Strength Levels
    func strengthLevel(for sticky: Sticky) -> StrengthLevel {
        if let strength = sticky.strength {
            switch strength {
            case 0.0..<0.30: return .weak
            case 0.30..<0.66: return .moderate
            default: return .strong //0.66 - 1.0
            }
        }
        return .none
    }
    
    //MARK: - Build session
    func buildStudySession(from stickies: [Sticky], filter: StrengthFilter) -> [Sticky] {
        //Apply filter
        var session = applyFilter(stickies, filter)
        
        //Always remove mastered cards
        session.removeAll { ($0.isMastered ?? false) == true }
        
        //Return new shuffled session
        return session.shuffled()
    }
    
    private func applyFilter(_ stickies: [Sticky], _ filter: StrengthFilter) -> [Sticky] {
        switch filter {
        case .all:
            return stickies
            
        case .weak:
            return self.filter(stickies, by: .weak)
            
        case .medium:
            return self.filter(stickies, by: .moderate)
            
        case .strong:
            return self.filter(stickies, by: .strong)
        }
    }
    
    //MARK: - Main logic methods
    func markCorrect(_ sticky: Sticky) {
        sticky.timesCorrect? += 1
        sticky.lastReviewedDate = Date()
        
        //Update strength
        guard let strength = sticky.strength else { return }
        
        //set new strength to current strength + 15% more
        let strengthRate = StrengthLevel.strengthRate
        
        sticky.strength = min(1.0, strength + strengthRate)
        sticky.isInMistakePool = false
    }
    
    func markIncorrect(_ sticky: Sticky) {
        sticky.timesIncorrect? += 1
        sticky.lastReviewedDate = Date()
        
        guard let strength = sticky.strength else { return }
        
        //Get penalty percentage for incorrect answer
        let level = strengthLevel(for: sticky)
        let strengthPenaltyDecayRate = level.penaltyDecayRate
        
        sticky.strength = max(0.0, strength - strengthPenaltyDecayRate)
        sticky.isInMistakePool = true
    }
    
    func markMastered(_ sticky: Sticky) {
        sticky.previousStrength = sticky.strength //store old strength
        sticky.strength = 1.0 //mastered = max strength
        sticky.isMastered = true
        sticky.isInMistakePool = false
    }
    
    func unmarkMastered(_ sticky: Sticky) {
        sticky.isMastered = false
        
        if let prev = sticky.previousStrength {
            sticky.strength = prev
        }else {
            sticky.strength = 0.5 //fallback
        }
        sticky.previousStrength = nil
    }
    
    //MARK: - Decay methods
    
    //Apply strength decay to all stickies in a deck
    func applyDecay(to stickies: [Sticky]) {
        stickies.forEach { applyDecay($0) }
    }
    
    //Applies natural memory decay based on last review date
    //Strong cards take atleast 7 days+ to drop a level to moderate
    //Moderate cards take anywhere from 4-7 days to drop to weak depending on how strong
    //Weak cards drop 10% every day
    private func applyDecay(_ sticky: Sticky) {
        //Do not apply decay if card is marked as mastered
        let notAvailable = sticky.isMastered == nil
        if !notAvailable {
            if let mastered = sticky.isMastered {
                guard !mastered else {
                    return //Skip decay if sticky is mastered
                }
            }
        }
       
        guard let lastReviewedDate = sticky.lastReviewedDate,
              let strength = sticky.strength else { return }
        
        let now = Date()
        
        //If decay was applied recently, skip this
        if let lastDecay = sticky.lastDecayAppliedDate {
            let hoursSinceLastDecay = now.timeIntervalSince(lastDecay) / 3600
            if hoursSinceLastDecay < 24 {
                return //if less than 24 hours has passed since last decay, prevent repeated decay within the day
            }
        }
        
        //Get how many days since the last review of this sticky card (86400 seconds in a day)
        let days = now.timeIntervalSince(lastReviewedDate) / 86400
        guard days >= 1 else {
            return
        } //Don't decay card within the same day, should be once per day when the stickies list is viewed for a deck
        
        let level = strengthLevel(for: sticky) //check current level
        let dailyDecayRate = level.dailyDecayRate //gets decay rate based on current level
        
        let newStrength = strength - (dailyDecayRate * days)
        sticky.strength = max(0.0, newStrength) //set new strength, if its lower than 0 then clamp it at 0
        
        //Mark when last decay was applied
        sticky.lastDecayAppliedDate = now
    }
    
    //MARK: - Filter/Sorting methods
    func filter(_ stickies: [Sticky], by strength: StrengthLevel) -> [Sticky] {
        return stickies.filter { strengthLevel(for: $0) == strength }
    }
    
    func sortedByStrength(_ stickies: [Sticky]) -> [Sticky] {
        return stickies.sorted { $0.strength ?? 0 < $1.strength ?? 0 }
    }
    
    func shuffled(_ stickies: [Sticky]) -> [Sticky] {
        return stickies.shuffled()
    }
}
