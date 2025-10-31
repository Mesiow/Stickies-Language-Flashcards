//
//  LanguageCardView.swift
//  Stickies
//
//  Created by Chris W on 10/29/25.
//

import SwiftUI

struct LanguageCardView: View {
    let language: Language
    let offset: CGFloat = 4
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(AppInfo.stickyNoteBackgroundTintColor)
                .offset(y: offset)
            
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(AppInfo.stickyNoteTintColor)
                .offset(y: 0)
            
            VStack(alignment: .center, spacing: 6) {
                Text(language.flag)
                    .font(.system(size: 34)) //slight increase for visual weight
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
