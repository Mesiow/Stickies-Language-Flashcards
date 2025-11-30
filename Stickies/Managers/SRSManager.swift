//
//  SRSManager.swift
//  Stickies
//
//  Created by Chris W on 11/26/25.
//

import SwiftUI

//Strength Decay based SRS (Spaced Repetition System) Manager
final class SRSManager {
    static let shared = SRSManager()
    private init() { }
    
    // MARK: - Strength Levels
    /*enum StrengthLevel {
        case weak
        case medium
        case strong
        case unknown
    }*/
    
    func strengthLevel(for sticky: Sticky) -> StrengthLevel {
        if let strength = sticky.strength {
            switch strength {
            case 0.0..<0.33: return .weak
            case 0.33..<0.66: return .moderate
            default: return .strong
            }
        }
        return .none
    }
    
    //MARK: - Main logic methods
    func markCorrect(_ sticky: Sticky) {
        sticky.timesCorrect? += 1
        sticky.lastReviewedDate = Date()
        
        //Update strength
        guard let strength = sticky.strength else { return }
        
        //set new strength to current strength + 15% more
        let strengthRate = 0.15
        sticky.strength = min(1.0, strength + strengthRate)
        sticky.isInMistakePool = false
        print("correct")
    }
    
    func markIncorrect(_ sticky: Sticky) {
        sticky.timesIncorrect? += 1
        sticky.lastReviewedDate = Date()
        
        guard let strength = sticky.strength else { return }
        
        //set new strength to current strength - 25% decay rate
        let strengthDecayRate = 0.25
        sticky.strength = max(0.0, strength - strengthDecayRate)
        sticky.isInMistakePool = true
        print("incorrect")
    }
    
    //MARK: - Decay methods
    
    //Apply strength decay to all stickies in a deck
    func applyDecay(to stickies: [Sticky]) {
        stickies.forEach { applyDecay($0) }
    }
    
    // Applies natural memory decay based on last review date
    private func applyDecay(_ sticky: Sticky) {
        guard let lastReviewedDate = sticky.lastReviewedDate, let strength = sticky.strength else { return }
        
        //Get how many days since the last review of this sticky card (86400 seconds in a day)
        let days = Date().timeIntervalSince(lastReviewedDate) / 86400
        let decayRate = 0.08 //8% decay per day
        
        let newStrength = strength - (decayRate * days)
        sticky.strength = max(0.0, newStrength) //set new strength, if its lower than 0 then clamp it at 0
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
