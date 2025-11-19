//
//  StudyModeCompletedStatisticsView.swift
//  Stickies
//
//  Created by Chris W on 11/17/25.
//

import SwiftUI

struct StudyModeCompletedStatisticsView: View {
    let correct: Int
    let incorrect: Int
    let onClose: () -> Void
    
    var percentageCorrect: Int {
        let total = correct + incorrect
        guard total > 0 else { return 0 }
        return Int((Double(correct) / Double(total)) * 100)
    }

    var body: some View {
        ZStack {
            // Dim background
            Rectangle()
                .fill(.ultraThinMaterial.opacity(0.90))    // actual blur
                .background(Color.black.opacity(0.25))  // dim
                .transition(.opacity)
                .ignoresSafeArea(.all)
            
            // Popup card
            VStack(spacing: 15) {
                Text("Results")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("\(percentageCorrect)%")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.black.opacity(0.75))

                
                VStack(spacing: 12) {
                    HStack {
                        Text("Remembered")
                            .fontWeight(.medium)
                        Text("\(correct)")
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("Forgot")
                            .fontWeight(.medium)
                        Text("\(incorrect)")
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                    }
                }
                .font(.system(size: 18))
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
                
                if incorrect > 0 {
                    Button {
                        //Review mistakes
                    }label: {
                        Text("Review Mistakes")
                            .foregroundStyle(.white.opacity(0.85))
                            .fontWeight(.medium)
                            .font(.system(size: 18, weight: .semibold))
                            .padding(.vertical, 8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .padding(.horizontal)
                    .buttonStyle(DepthButtonStyle(
                        foregroundColor: AppInfo.secondaryButtonBackgroundTintColor,
                        backgroundColor: AppInfo.secondaryButtonTintColor))
                }
                
                Button {
                    onClose()
                } label: {
                    Text("Done")
                        .fontWeight(.medium)
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: 44)
                .padding(.horizontal)
                .buttonStyle(DepthButtonStyle(
                    foregroundColor: AppInfo.actionButtonTintColor,
                    backgroundColor: AppInfo.mainTintColor))
            }
            .padding()
            .frame(maxWidth: 345)
            .background(AppInfo.stickyNoteTintColor.opacity(0.70).ignoresSafeArea())
            .cornerRadius(20)
            .padding()
            .offset(y: -80)
            .transition(.scale.combined(with: .opacity))
        }
    }
}
