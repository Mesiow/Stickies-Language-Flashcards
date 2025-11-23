//
//  Sticky.swift
//  Stickies
//
//  Created by Chris W on 10/29/25.
//

import SwiftUI
import SwiftData

//Sticky Note Card that the user uses to study vocab with
@Model
final class Sticky: Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    
    //each sticky is part of one language
    //@Relationship var language: Language
    
    //Each sticky is part of a deck
    @Relationship var deck: Deck
    
    var foreignWord: String //word or phrase to learn
    var translation: String //on the back of the sticky
    var pronunciation: String? //how to pronounce the word correctly
    var examplePhrase: String?
    
    var createdAt: Date
   
    //Fields for Strength Decay Based SRS (Spaced Repetition System)
    //Each word has a “strength bar” that gradually weakens unless practiced.
    var strength: Double? //value of 0.0 to 1.0 telling us how well we know the word,
                         //0 = new word don't know well at all, 1 = fully mastered
    var lastReviewedDate: Date? //the last time the card was reviewed, used for calculating how much strength should decay
    var timesCorrect: Int? //how many times the user answered the card correctly
    var timesIncorrect: Int? //how many times the user answered the card incorrectly
    var isInMistakePool: Bool? //(used for reviewing mistakes, etc)
    
    
    init(id: UUID = UUID(), deck: Deck, foreignWord: String, translation: String, pronunciation: String? = nil, examplePhrase: String? = nil) {
        self.id = id
        self.deck = deck
        self.foreignWord = foreignWord
        self.translation = translation
        self.pronunciation = pronunciation
        self.examplePhrase = examplePhrase
        
        self.createdAt = Date()
        
        //SRS vars
        self.strength = 0.0 //every word starts at 0
        self.lastReviewedDate = Date()
        self.timesCorrect = 0
        self.timesIncorrect = 0
        self.isInMistakePool = false
    }
}
