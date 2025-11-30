//
//  ShuffleCapsuleToggle.swift
//  Stickies
//
//  Created by Chris W on 11/30/25.
//

import SwiftUI

/*struct ShuffleCapsuleToggle: View {
    @Binding var isOn: Bool

    private let backgroundColor = AppInfo.stickyNoteTintColor
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                isOn.toggle()
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "shuffle")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)

                Text("Shuffle")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .background(
                Capsule()
                    .fill(backgroundColor.opacity(isOn ? 1.0 : 0.55))
            )
            .overlay(
                Capsule()
                    .stroke(.black.opacity(isOn ? 0.3 : 0), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}*/

struct ShuffleSliderToggle: View {
    @Binding var isOn: Bool
    
    private let capsuleColor = AppInfo.stickyNoteTintColor
    private let knobSize: CGFloat = 21
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                isOn.toggle()
            }
        } label: {
            HStack(spacing: 8) {
                // Label + icon
                Image(systemName: "shuffle")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)
                
                Text("Shuffle")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)
                
                // Toggle container
                ZStack(alignment: isOn ? .trailing : .leading) {
                    Capsule()
                        .fill(isOn ? Color.green : Color.black.opacity(0.25))
                        .frame(width: 45, height: 18)
                        .overlay(
                            Capsule()
                                .stroke(.black.opacity(0.25), lineWidth: 1)
                        )
                    
                    Circle()
                        .fill(.white)
                        .frame(width: knobSize, height: knobSize)
                        .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
                }
                .padding(.leading, 4)
                .padding(.trailing, 2)
                .frame(width: 55, height: 20)
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .background(
                Capsule()
                    .fill(capsuleColor)
            )
            .fixedSize(horizontal: true, vertical: false)
            .frame(maxWidth: .none)
        }
        .buttonStyle(.plain)
    }
}


