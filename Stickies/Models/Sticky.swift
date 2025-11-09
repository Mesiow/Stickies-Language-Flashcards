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
    @Relationship var language: Language
    
    var foreignWord: String //word or phrase to learn
    var translation: String //on the back of the sticky
    var pronunciation: String? //how to pronounce the word correctly
    var examplePhrase: String?
    var bucket: Int //bucket 0, 1, 2 for spaced repition (leitners system)
    var nextReview: Date //when its due to review
    
    init(id: UUID = UUID(), language: Language, foreignWord: String, translation: String, pronunciation: String? = nil, examplePhrase: String? = nil) {
        self.id = id
        self.language = language
        self.foreignWord = foreignWord
        self.translation = translation
        self.pronunciation = pronunciation
        self.examplePhrase = examplePhrase
        self.bucket = 0 //new card starts at bucket 0
        self.nextReview = Date() //immediate review
    }
}
