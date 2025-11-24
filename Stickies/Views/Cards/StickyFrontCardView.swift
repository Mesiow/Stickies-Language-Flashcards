//
//  StickyFrontCardView.swift
//  Stickies
//
//  Created by Chris W on 11/20/25.
//

import SwiftUI

struct StickyFrontCardView: View {
    let sticky: Sticky

    var body: some View {
        ZStack {
            StickyNoteStyleView()
                .padding(.horizontal, 25)
            
            VStack {
                Text(sticky.foreignWord)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Text("Tap To Reveal")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.gray)
                    .opacity(0.8)
                    .padding(.top, 4)
            }
        }
    }
}
