//
//  HomeViewModel.swift
//  Stickies
//
//  Created by Chris W on 10/28/25.
//

import SwiftUI
import SwiftData
import Combine

final class HomeViewModel: ObservableObject {
    
    //Model context from SwiftData
    private var modelContext: ModelContext
    
    //Grid Layout
    let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let languages = popularLanguages.map { LanguageItem(code: $0.code, name: $0.name, image: $0.image) }
    
    //Published state vars
    @Published var isEditing: Bool = false
    @Published var showDeleteLangConfirmation = false
    @Published var languageToDelete: Language? = nil
    
    init(context: ModelContext) {
        self.modelContext = context
    }
    
    func addLanguage(_ language: Language) {
        modelContext.insert(language)
        try? modelContext.save()
    }
    
    func deleteLanguage(_ language: Language) {
        modelContext.delete(language) // this automatically deletes stickies too
        try? modelContext.save()
    }
    
    func addNewSticky(for language: Language, sticky: Sticky) {
        language.stickies.append(sticky)
        try? modelContext.save()
    }
    
    func updateSticky(_ sticky: Sticky, foreignWord: String, translation: String, pronunciation: String, exampleSentence: String) {
        sticky.foreignWord = foreignWord
        sticky.translation = translation
        sticky.pronunciation = pronunciation
        sticky.examplePhrase = exampleSentence
        try? modelContext.save()
    }
    
    func deleteSticky(for language: Language, sticky: Sticky) {
        language.stickies.removeAll { s in
            s.id == sticky.id
        }
        try? modelContext.save()
    }
}
