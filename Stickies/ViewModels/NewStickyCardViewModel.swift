//
//  NewStickyCardViewModel.swift
//  Stickies
//
//  Created by Chris W on 11/7/25.
//

import SwiftUI
import Combine

final class NewStickyCardViewModel: ObservableObject {
    @Published var foreignWord: String = ""
    @Published var translation: String = ""
    @Published var pronunciation: String? = nil
    @Published var exampleSentence: String? = nil
    @Published var isMastered: Bool = false //Option only shown on existing stickies
    
    @Published var didLoadExisting = false //checks if we loaded an existing item for editing
    @Published var showInputAlert = false
    
    func loadExisting(existingSticky: Sticky) {
        foreignWord = existingSticky.foreignWord
        translation = existingSticky.translation
        pronunciation = existingSticky.pronunciation
        exampleSentence = existingSticky.examplePhrase
        isMastered = existingSticky.isMastered ?? false
    }
}
