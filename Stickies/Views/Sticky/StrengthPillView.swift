//
//  StrengthPillView.swift
//  Stickies
//
//  Created by Chris W on 11/25/25.
//

import SwiftUI

struct StrengthIndicatorView: View {
    let strength: StrengthLevel
    var width: CGFloat = 6
    var height: CGFloat = 3
    
    var body: some View {
        Capsule()
            .fill(strength.barColor)
            .frame(width: width, height: height)
    }
}

struct StrengthPillView: View {
    let title: String
    let isSelected: Bool
    let strengthLevel: StrengthLevel    // 0 = none (for "All"), 1, 2, 3
    let active: Bool //determines whether this will be active for selecting (if no cards have this strength level it will be inactive)
    let action: () -> Void
    
    // Strength colors
    private let weakColor = Color.red
    private let mediumColor = Color.orange
    private let strongColor = Color.green
    
    // App yellow
    private let pillBackground = AppInfo.stickyNoteTintColor
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .foregroundStyle(.black)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
                    
                
                // Bars indicator
                if strengthLevel.rawValue != StrengthLevel.none.rawValue {
                    HStack(spacing: 2) {
                        ForEach(0..<strengthLevel.rawValue, id: \.self) { strength in
                            StrengthIndicatorView(strength: strengthLevel)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .background(
                Capsule()
                    .fill(isSelected ? pillBackground.opacity(1.0) : pillBackground.opacity(0.35))
            )
            .overlay(
                Capsule()
                    .stroke(.black.opacity(isSelected ? 0.25 : 0.15), lineWidth: 1)
            )
        }
        .disabled(!active)
        .opacity(active ? 1 : 0.60)
        .animation(.easeInOut(duration: 0.2), value: active)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .buttonStyle(.plain)
    }
}

