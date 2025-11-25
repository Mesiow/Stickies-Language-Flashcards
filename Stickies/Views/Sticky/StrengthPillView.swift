//
//  StrengthPillView.swift
//  Stickies
//
//  Created by Chris W on 11/25/25.
//

import SwiftUI

import SwiftUI

enum PillStrengthLevel: Int {
    case none, weak, moderate, strong
}

struct StrengthPillView: View {
    let title: String
    let isSelected: Bool
    let strengthLevel: PillStrengthLevel    // 0 = none (for "All"), 1, 2, 3
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
                if strengthLevel.rawValue != PillStrengthLevel.none.rawValue {
                    HStack(spacing: 2) {
                        ForEach(0..<strengthLevel.rawValue, id: \.self) { index in
                            Capsule()
                                .fill(barColor)
                                .frame(width: 6, height: 3)
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
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .buttonStyle(.plain)
    }
    
    // Determine bar color based on strength level
    private var barColor: Color {
        switch strengthLevel {
        case .weak: return weakColor
        case .moderate: return mediumColor
        case .strong: return strongColor
        default: return .clear
        }
    }
}

