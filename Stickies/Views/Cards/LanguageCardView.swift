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
                FlagImageView(image: language.image, width: 46, height: 36)
                
                Text(language.name)
                    .fontWeight(.medium)
                    .padding(.top, 2)
                Text(
                    language.stickies.isEmpty
                    ? "No stickies yet"
                    : "\(language.stickies.count) \(language.stickies.count == 1 ? "sticky" : "stickies")"
                )
                .multilineTextAlignment(.center)
                .fontWeight(.regular)
                .opacity(0.6)
            }
            .padding(10)
            .frame(maxWidth: .infinity, minHeight: 150, idealHeight: 170)
        }
    }
}
