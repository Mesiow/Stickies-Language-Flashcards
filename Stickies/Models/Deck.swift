//
//  Deck.swift
//  Stickies
//
//  Created by Chris W on 11/21/25.
//

import SwiftUI
import SwiftData
import Combine

@Model
class Deck: Identifiable, Hashable {
    var id: UUID?
    
    var name: String?
    
    //each deck is part of a language
    @Relationship var language: Language?
    
    //If a deck is deleted all the sticky flashcards associated with it are also deleted
    @Relationship(deleteRule: .cascade)
    var stickies: [Sticky]?
    
    var unwrappedStickies: [Sticky] {
        stickies ?? []
    }
    
    var sortedStickies: [Sticky] {
        unwrappedStickies.sorted { $0.createdAt ?? Date() < $1.createdAt ?? Date() }
    }

    init(id: UUID = UUID(), language: Language, name: String, stickies: [Sticky] = []) {
        self.id = id
        self.name = name
        self.language = language
        self.stickies = []
    }
}
