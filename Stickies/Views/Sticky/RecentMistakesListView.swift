//
//  RecentMistakesListView.swift
//  Stickies
//
//  Created by Chris W on 12/2/25.
//

import SwiftUI

struct RecentMistakesListView: View {
    
    @Bindable var deck: Deck
    
    private var stickiesInMistakePool: [Sticky] {
        deck.stickies.filter { $0.isInMistakePool == true }
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical){
                VStack {
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 22) {
                        ForEach(stickiesInMistakePool, id: \.id) { sticky in
                            StickyNoteCardMistakeView(sticky: sticky)
                        }
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 4)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Recent Mistakes")
        .background(
            AppInfo.backgroundColor.ignoresSafeArea()
        )
    }
}
