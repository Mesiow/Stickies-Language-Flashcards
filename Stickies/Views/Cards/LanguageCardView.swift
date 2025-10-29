//
//  LanguageCardView.swift
//  Stickies
//
//  Created by Chris W on 10/29/25.
//

import SwiftUI

struct LanguageCardView: View {
    let language: Language
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(language.flag)
                .font(.system(size: 34)) //slight increase for visual weight
            Text(language.name)
                .font(.headline)
                .padding(.top, 2)
            Text(
                language.stickies.isEmpty
                ? "No stickies yet"
                : "\(language.stickies.count) \(language.stickies.count == 1 ? "sticky" : "stickies")"
            )
            .font(.caption)
            .opacity(0.6)
        }
        .padding(10)
        .frame(maxWidth: .infinity, minHeight: 150, idealHeight: 170, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.white) // off-white card
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(.lightGray).opacity(0.25), lineWidth: 1) // subtle stationery border
                )
                .shadow(radius: 2, y: 2)
        )
    }
}
