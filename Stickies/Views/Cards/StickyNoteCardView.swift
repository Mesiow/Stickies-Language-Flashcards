//
//  StickyNoteCardView.swift
//  Stickies
//
//  Created by Chris W on 10/30/25.
//

import SwiftUI

struct StickyNoteCardView: View {
    
    var sticky: Sticky
    
    var body: some View {
        ZStack(alignment: .topLeading) {
           StickyNoteStyleView()
            
            HStack {
                Spacer()
                FlagImageView(image: sticky.deck.language.image, width: 24, height: 24)
            }
            .padding(.top, 8)
            .padding(.horizontal, 8)
            
            VStack(alignment: .center) {
                Spacer()
                Text(sticky.foreignWord)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
        .padding(.horizontal)
    }
}
