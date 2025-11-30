//
//  CreateNewStickyCardView.swift
//  Stickies
//
//  Created by Chris W on 11/30/25.
//

import SwiftUI

struct CreateNewStickyCardView: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: SFSymbols.plus)
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.semibold)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.black.opacity(0.8))
                
                Text("Create new sticky note flashcard")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black)
                
                Text("Create words to review and practice your vocabulary")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 26)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppInfo.stickyNoteTintColor.opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [6, 4]))
                    .foregroundStyle(.black.opacity(0.35)) //dashed border
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
    }
}
