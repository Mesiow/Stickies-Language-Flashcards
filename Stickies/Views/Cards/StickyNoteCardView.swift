//
//  StickyNoteCardView.swift
//  Stickies
//
//  Created by Chris W on 10/30/25.
//

import SwiftUI

struct StickyNoteCardView: View {
    
    var sticky: Sticky
    let offset: CGFloat = 4
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(AppInfo.stickyNoteBackgroundTintColor)
                .offset(y: offset)
                .shadow(color: .black.opacity(0.1), radius: 1, y: 1)
            
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(AppInfo.stickyNoteTintColor)
                .offset(y: 0)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(sticky.foreignWord)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.black)
                    Text(sticky.translation)
                        .font(.system(size: 19, weight: .medium))
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 110, maxHeight: 130)
        .padding(.horizontal)
    }
}
