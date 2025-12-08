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
            
            VStack {
                Text(sticky.translation)   // translation
                    .font(.system(size: 29, weight: .semibold))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(0.7)
                    .padding(.horizontal)
                
                if let pronunciation = sticky.pronunciation {
                    Text(pronunciation)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.black)
                        .opacity(0.7)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.8)
                        .padding(.top, 4)
                        .padding(.horizontal, 4)
                }
                if let examplePhrase = sticky.examplePhrase {
                    Text(examplePhrase)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.gray)
                        .opacity(0.8)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 4)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity, minHeight: 350, maxHeight: 350)
        .padding(.horizontal, 25)
        .rotation3DEffect(.degrees(180), axis: (0, 1, 0))
    }
}
