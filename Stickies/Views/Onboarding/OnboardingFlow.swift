//
//  OnboardingFlow.swift
//  Invoice Maker
//
//  Created by Chris W on 8/16/25.
//

import SwiftUI

struct OnboardingFlow: View {
    
    //Onboarding steps
    enum Step {
        case intro
        case tutorial
    }
    
    @State private var step: Step = .intro

    let onFinish: () -> Void

    var body: some View {
        ZStack {
            switch step {
            case .intro:
                OnboardingView(appName: AppInfo.name, color: AppInfo.mainTintColor, onContinue: {
                    withAnimation(.smooth(duration: 0.30)) {
                        step = .tutorial
                    }
                })
                .transition(.push(from: .trailing))

            case .tutorial:
                OnboardingTutorialView(onCompleted: {
                    onFinish()
                })
                .transition(.push(from: .trailing))
            }
        }
    }
}

