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
                FlagImageView(image: sticky.language.image, width: 24, height: 24)
            }
            .padding(.top, 8)
            .padding(.horizontal, 8)
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(sticky.foreignWord)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.black)
                Text(sticky.translation)
                    .font(.system(size: 19, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 110, maxHeight: 130)
        .padding(.horizontal)
    }
}
