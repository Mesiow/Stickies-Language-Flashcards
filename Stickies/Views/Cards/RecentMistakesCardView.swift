//
//  RecentMistakesCardView.swift
//  Stickies
//
//  Created by Chris W on 12/1/25.
//

import SwiftUI

struct RecentMistakesCardView: View {
    var active: Bool //determines whether this is shown as disabled or tappable (depends on if any cards are in the mistake pool)
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: SFSymbols.xmarkAppFill)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(active ? .red.opacity(0.8) : .gray.opacity(0.70))

                Text("Recent mistakes")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(active ? .black : .gray.opacity(0.70))
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                AppInfo.stickyNoteTintColor .opacity(active ? 0.85 : 0.70)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .disabled(!active)
    }
}

