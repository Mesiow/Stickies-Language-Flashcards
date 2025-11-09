//
//  StickyNoteStyleFlapView.swift
//  Stickies
//
//  Created by Chris W on 11/8/25.
//

import SwiftUI

struct StickyNoteStyleFlapView: View {
    private let mainColor = Color(red: 1.0, green: 0.97, blue: 0.80) // pale yellow
    private let flapColor = Color(red: 1.0, green: 0.90, blue: 0.40) // deeper yellow
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 6)
                .fill(AppInfo.stickyNoteBackgroundTintColor)
                .offset(y: 4)
                .shadow(color: .black.opacity(0.1), radius: 1, y: 1)
            
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(AppInfo.stickyNoteTintColor)
                .offset(y: 0)
            
            // 🟨 Folded corner flap
           /* CurledCornerFlap(size: 32, cornerRadius: 6)
                .fill(AppInfo.stickyNoteBackgroundTintColor)
                //.offset(x: -1, y: -1) // subtle alignment tweak*/
        }
    }
}
