//
//  StickyNoteCardView.swift
//  Stickies
//
//  Created by Chris W on 10/30/25.
//

import SwiftUI

struct StickyNoteCardView: View {
    
    var sticky: Sticky
    
    private var strengthLevel: StrengthLevel {
        return SRSManager.shared.strengthLevel(for: sticky)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
           StickyNoteStyleView()
            
            HStack {
                Spacer()
                FlagImageView(image: sticky.deck?.language?.image ?? popularLanguages[0].image, width: 24, height: 24)
            }
            .padding(.top, 8)
            .padding(.horizontal, 8)
            
            VStack(alignment: .center) {
                Spacer()
                Text(sticky.foreignWord ?? "Word")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.black)
                    .minimumScaleFactor(0.8)
                    .padding(.trailing, 12)
                
                Spacer()
            }
            .padding()
            .padding(.trailing, 12)
        }
        //Strength indicator
        .overlay(alignment: .bottomTrailing) {
            HStack(spacing: 2) {
                if let mastered = sticky.isMastered {
                    if mastered {
                        Image(systemName: SFSymbols.checkmarkSealFill)
                            .foregroundStyle(.green)
                            .font(.system(size: 12))
                    }
                }
                ForEach(0..<strengthLevel.rawValue, id: \.self) { strength in
                    StrengthIndicatorView(strength: strengthLevel, width: 8, height: 4)
                }
            }
            .padding(.trailing, 12)
            .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
        .padding(.horizontal)
    }
}
