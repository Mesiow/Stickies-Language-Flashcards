//
//  NewStickyCardView.swift
//  Stickies
//
//  Created by Chris W on 11/1/25.
//

import SwiftUI

struct NewStickyCardView: View {
    var body: some View {
        VStack {
            ZStack {
                
                StickyNoteStyleView()
                
                /* HStack {
                 VStack(alignment: .leading, spacing: 4) {
                 
                 }
                 Spacer()
                 }
                 .padding()*/
            }
        }
        .navigationTitle("New Sticky")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, minHeight: 420, maxHeight: 450)
        .padding(.horizontal)
        .background(
            AppInfo.secondaryTintColor.opacity(0.35).ignoresSafeArea()
        )
    }
}

#Preview {
    NewStickyCardView()
}
