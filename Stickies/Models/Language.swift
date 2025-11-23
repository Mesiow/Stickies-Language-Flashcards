//
//  Language.swift
//  Stickies
//
//  Created by Chris W on 10/29/25.
//

import SwiftUI
import SwiftData
import Combine

@Model
class Language: Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    
    var code: String
    var name: String
    var image: String
    
    @Relationship(deleteRule: .cascade)
    var decks: [Deck]
    
    init(id: UUID = UUID(), code: String, name: String, image: String, decks: [Deck] = []) {
        self.id = id
        self.code = code
        self.name = name
        self.image = image
        self.decks = decks
    }
    
}
