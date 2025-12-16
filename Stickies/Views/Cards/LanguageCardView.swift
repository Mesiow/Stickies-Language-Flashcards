//
//  LanguageCardView.swift
//  Stickies
//
//  Created by Chris W on 10/29/25.
//

import SwiftUI

struct LanguageCardView: View {
    
    let language: Language
    
    var body: some View {
        ZStack {
            StickyNoteStyleView()
            
            VStack(alignment: .center, spacing: 6) {
                FlagImageView(image: language.image ?? popularLanguages[0].image, width: 50, height: 40)
                
                Text(language.name ?? "Language")
                    .fontWeight(.semibold)
                    .padding(.top, 2)
                Text(
                    language.unwrappedDecks.isEmpty
                    ? "No decks yet"
                    : "\(language.unwrappedDecks.count) \(language.unwrappedDecks.count == 1 ? "deck" : "decks")"
                )
                .multilineTextAlignment(.center)
                .fontWeight(.medium)
                .opacity(0.7)
            }
            .padding(10)
            .frame(maxWidth: .infinity, minHeight: 150, idealHeight: 170)
        }
    }
}
