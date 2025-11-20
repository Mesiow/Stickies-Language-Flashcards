//
//  StickyBackCardView.swift
//  Stickies
//
//  Created by Chris W on 11/20/25.
//

import SwiftUI

struct StickyBackCardView: View {
    let sticky: Sticky

    var body: some View {
        ZStack {
            StickyNoteStyleView()
                .padding(.horizontal, 25)
            
            VStack {
                Text(sticky.translation)   // translation
                    .font(.system(size: 29, weight: .semibold))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text(sticky.examplePhrase ?? "")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.gray)
                    .opacity(0.8)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
                    .padding(.horizontal, 4)
            }
            .padding(.horizontal, 8)
        }
        .rotation3DEffect(.degrees(180), axis: (0, 1, 0))
    }
}
