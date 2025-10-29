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
    
    var foreignWord: String //word or phrase to learn
    var translation: String //on the back of the sticky
    var examplePhrase: String?
    var bucket: Int //bucket 0, 1, 2 for spaced repition (leitners system)
    var nextReview: Date //when its due to review
    
    init(id: UUID = UUID(), foreignWord: String, translation: String, examplePhrase: String? = nil) {
        self.id = id
        self.foreignWord = foreignWord
        self.translation = translation
        self.examplePhrase = examplePhrase
        self.bucket = 0 //new card starts at bucket 0
        self.nextReview = Date() //immediate review
    }
}
