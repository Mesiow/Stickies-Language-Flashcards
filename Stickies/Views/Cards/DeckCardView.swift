//
//  DeckCardView.swift
//  Stickies
//
//  Created by Chris W on 11/21/25.
//

import SwiftUI

struct DeckCardView: View {
    let deck: Deck
    
    var body: some View {
        ZStack {
            StickyNoteStyleView()
            
            VStack(alignment: .center, spacing: 6) {
                //FlagImageView(image: deck.language.image, width: 36, height: 26)
                Text(deck.name)
                    .font(.system(size: 18, weight: .medium))
                    .padding(.top, 2)
                Text(
                    deck.stickies.isEmpty
                    ? "No stickies yet"
                    : "\(deck.stickies.count) \(deck.stickies.count == 1 ? "sticky" : "stickies")"
                )
                .multilineTextAlignment(.center)
                .font(.system(size: 14, weight: .regular))
                .opacity(0.6)
            }
            .padding(10)
            .frame(maxWidth: .infinity, minHeight: 120, idealHeight: 120)
        }
    }
}
