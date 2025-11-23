//
//  StickyNoteStyleView.swift
//  Stickies
//
//  Created by Chris W on 11/1/25.
//

import SwiftUI

struct StickyNoteStyleView: View {
    
    var color: Binding<Color>? = nil
    let offset: CGFloat = 4
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(AppInfo.stickyNoteBackgroundTintColor)
                .offset(y: offset)
                .shadow(color: .black.opacity(0.1), radius: 1, y: 1)
            
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(AppInfo.stickyNoteTintColor)
                .offset(y: 0)
        }
    }
    
    /*func frontColor() -> Color {
        let front = color?.wrappedValue ?? AppInfo.stickyNoteTintColor
        return front
    }
    
    func backColor() -> Color {
        var back = AppInfo.stickyNoteBackgroundTintColor
        if let color = color {
            if color.wrappedValue != frontColor() {
                back = frontColor().darken(by: 0.05)
            }
        }
        return back
    }*/
}
