//
//  StickyNoteCardView.swift
//  Stickies
//
//  Created by Chris W on 10/30/25.
//

import SwiftUI

struct StickyNoteCardView: View {
    
    var sticky: Sticky
    //@State private var isTranslationBlurred = true
    
    var body: some View {
        ZStack(alignment: .topLeading) {
           StickyNoteStyleView()
            
            HStack {
                Spacer()
                FlagImageView(image: sticky.language.image, width: 24, height: 24)
            }
            .padding(.top, 8)
            .padding(.horizontal, 8)
            
            
            VStack(alignment: .center) {
                Spacer()
                Text(sticky.foreignWord)
                    .font(.system(size: 29, weight: .semibold))
                    .foregroundStyle(.black)
                Spacer()
                //Blur translation unless user taps eye
              /*  HStack {
                    Text(sticky.translation)
                        .font(.system(size: 19, weight: .medium))
                        .foregroundStyle(.black.opacity(0.85))
                        .blur(radius: isTranslationBlurred ? 6.0 : 0.0)
                    
                    Button {
                        withAnimation {
                            isTranslationBlurred.toggle()
                        }
                    }label: {
                        ZStack {
                            Image(systemName: SFSymbols.eye)
                                .resizable()
                                .scaledToFit()
                                .opacity(isTranslationBlurred ? 1 : 0)
                            Image(systemName: SFSymbols.eyeSlash)
                                .resizable()
                                .scaledToFit()
                                .opacity(isTranslationBlurred ? 0 : 1)
                        }
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black.opacity(0.75))
                        .padding(.leading, 4)
                    }
                }*/
            }
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 90, maxHeight: 90)
        .padding(.horizontal)
    }
}
