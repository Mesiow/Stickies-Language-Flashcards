//
//  OnboardingTutorialView.swift
//  Stickies
//
//  Created by Chris W on 12/18/25.
//

import SwiftUI

struct OnboardingTutorialView: View {
    
    let onCompleted: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Strength indicator illustration
            VStack(alignment: .center, spacing: 40) {
                // Card with strength dots
                StickyNoteStyleView()
                    .frame(width: 280, height: 180)
                    .overlay(
                        VStack(spacing: 16) {
                            Text("Hello")
                                .font(.system(size: 32, weight: .bold))
                            
                            HStack(spacing: 6) {
                                ForEach(0..<StrengthLevel.strong.rawValue, id: \.self) { strength in
                                    StrengthIndicatorView(strength: .strong, width: 12, height: 6)
                                }
                            }
                            
                        }
                    )
                
                // Swipe indicators
                HStack {
                    VStack(spacing: 8) {
                        Image(systemName: SFSymbols.chevronLeftTwo)
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(.red)
                        Text("Need practice")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: SFSymbols.chevronRightTwo)
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.green)
                        Text("Know it")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 280)
                .padding(.horizontal, 60)
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 16) {
                Text("Master Your Vocab")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("Cards get stronger as you practice.\nSwipe cards in review mode to track progress")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            VStack {
                ZStack (alignment: .center) {
                    Button(action: {
                       onCompleted()
                    }) {
                        HStack {
                            Text("Get Started")
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .font(.title3.bold())
                    }
                    .frame(maxWidth: .infinity, maxHeight: 54)
                    .padding(.vertical, 8)
                    .buttonStyle(DepthButtonStyle(
                        foregroundColor: AppInfo.actionButtonTintColor,
                        backgroundColor: AppInfo.mainTintColor))
                    
                }
                .padding(.horizontal)
            }
            .padding(.top, 15)
            .padding(.bottom, 45)
            .padding(.horizontal,15)
        }
    }
}
