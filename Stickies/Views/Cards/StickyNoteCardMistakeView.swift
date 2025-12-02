//
//  StickyNoteCardMistakeView.swift
//  Stickies
//
//  Created by Chris W on 12/2/25.
//

import SwiftUI

//View for display sticky flashcards in the recent mistakes view
struct StickyNoteCardMistakeView: View {
    
    var sticky: Sticky
    
    var body: some View {
        ZStack(alignment: .topLeading) {
           StickyNoteStyleView()
            
            VStack(alignment: .leading) {
                Spacer()
                Text(sticky.foreignWord)
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(.black)
                Text(sticky.translation)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.black.opacity(0.85))
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
        .padding(.horizontal)
    }
}
