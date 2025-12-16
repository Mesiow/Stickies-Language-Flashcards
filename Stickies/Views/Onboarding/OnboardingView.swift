//
//  OnboardingView.swift
//
//  Created by Adam Lyttle on 2/5/2023.
//
//  adamlyttleapps.com
//  twitter.com/adamlyttleapps
//
//  Usage:
/*
OnboardingView(appName: "Real Estate Calculator", features: [
    Feature(title: "Mortgage Repayments", description: "Easily calculate weekly, monthly and yearly repayments ", icon: "house"),
    Feature(title: "Amortization", description: "Quickly view amortization for the life of the loan", icon: "chart.line.downtrend.xyaxis"),
    Feature(title: "Deposit Calculator", description: "Calculate deposit based on purchase price and savings", icon: "percent"),
    Feature(title: "Ad-Free Experience", description: "Thank you for downloading my app, I hope you enjoy it :-)", icon: "party.popper"),
], color: Color.blue)
*/

import SwiftUI

struct Feature: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String?
}

//Intro initial onboarding view
struct OnboardingView: View {
    @State var appName: String
    let color: Color?
    let onContinue: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to \(appName)")
                .foregroundStyle(.black.opacity(0.85))
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .padding(.vertical, 16)
                .padding(.horizontal)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .center)
        
            StickyMascotView(image: AppInfo.happyCharacter)
            
            //Single Benefit text
            Text("Create and review flashcards to learn new vocabulary")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                
           
            VStack {
                ZStack (alignment: .center) {
                    Button(action: {
                       onContinue()
                    }) {
                        HStack {
                            Text("Continue")
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
            
            Spacer()
        }
        .padding()
    }
}
