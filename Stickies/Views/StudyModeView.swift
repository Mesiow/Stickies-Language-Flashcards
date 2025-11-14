//
//  StudyModeView.swift
//  Stickies
//
//  Created by Chris W on 11/11/25.
//

import SwiftUI

struct StudyModeView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var language: Language
    
    @State private var currentCardIndex: Int = 0
    @State private var dragOffset: CGSize = .zero
    @State private var showEndStudyModeConfirmation = false
    @State private var nextCardBlur: CGFloat = 4.0 // control blur of next card to show
    
    let swipeThreshold: CGFloat = 150.0 //the threshold the card needs to reach on a swipe to be a successful swipe
    @State private var swipeOpacity: Double = 0 //controls tint and showing of checkmark/xmark when swiping

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 60)
                
                Text("Sticky \(currentCardIndex + 1) \\ \(language.stickies.count)")
                    .foregroundStyle(Color(UIColor.lightGray))
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                ZStack{
                    if !language.stickies.isEmpty {
                        //Next card underneath current card
                        if currentCardIndex < language.stickies.count - 1 {
                            let nextSticky = language.stickies[currentCardIndex + 1]
                            
                            StickyNoteStyleView()
                                .padding(.horizontal, 25)
                                .overlay(
                                    Text(nextSticky.foreignWord)
                                        .font(.system(size: 32, weight: .semibold))
                                        .foregroundStyle(.black)
                                        .multilineTextAlignment(.center)
                                        .blur(radius: nextCardBlur)
                                        .padding()
                                )
                                .animation(.easeInOut(duration: 0.3), value: nextCardBlur)
                        }
                        
                        ZStack {
                            //Current top card
                            StickyNoteStyleView()
                                .padding(.horizontal, 25)
                            
                            let sticky = language.stickies[currentCardIndex]
                            
                            Text(sticky.foreignWord)
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .id(currentCardIndex)
                        .offset(x: dragOffset.width)
                        .rotationEffect(.degrees(Double(dragOffset.width / 20)))
                        .overlay(
                            ZStack {
                                // show X mark or checkmark icon when swiping
                                if dragOffset.width > 0 {
                                    Image(systemName: SFSymbols.checkmarkCircleFill)
                                        .font(.system(size: 60, weight: .bold))
                                        .foregroundStyle(.green.opacity(0.85))
                                        .opacity(swipeOpacity)
                                        .offset(y: -60)
                                        .padding()
                                } else if dragOffset.width < 0 {
                                    Image(systemName: SFSymbols.xmarkCircleFill)
                                        .font(.system(size: 60, weight: .bold))
                                        .foregroundStyle(.red.opacity(0.85))
                                        .opacity(swipeOpacity)
                                        .offset(y: -60)
                                        .padding()
                                }
                            }
                            .padding(.horizontal, 25)
                        )
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    dragOffset = gesture.translation
                                    //Update swipe opacity
                                    let progress = min(abs(gesture.translation.width) / swipeThreshold, 1.0)
                                    swipeOpacity = progress   // animate icons/tint in
                                }
                                .onEnded{ gesture in
                                    if abs(gesture.translation.width) > swipeThreshold {
                                        let direction: CGFloat = gesture.translation.width > 0 ? 1 : -1 //right or left
                                        swipe(direction: direction)
                                    }else {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            //reset drag offset if not swiped enough
                                            dragOffset = .zero
                                        }
                                        
                                        withAnimation(.easeOut(duration: 0.25)) {
                                            swipeOpacity = 0    // fade out when cancelled
                                        }
                                    }
                                }
                        )
                        .animation(.easeInOut, value: dragOffset)
                        .zIndex(1) // ensures top card stays above next card
                        
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 360, maxHeight: 360)
                
                HStack {
                    HStack {
                        Image(systemName: SFSymbols.chevronLeftTwo)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.red)
                            .frame(width: 20, height: 20)
                        Text("Swipe left\n if you don't know it")
                            .frame(maxWidth: .infinity)
                    }
                    
                    HStack {
                        Text("Swipe right\n if you know it")
                            .frame(maxWidth: .infinity)
                        Image(systemName: SFSymbols.chevronRightTwo)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.green)
                            .frame(width: 20, height: 20)
                    }
                }
                .foregroundStyle(.black.opacity(0.7))
                .font(.system(size: 14))
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, 20)
                .padding(.vertical, 25)
                
                Spacer()
            }
            .overlay(
                ZStack {
                    // Show correct tint when swiping (correct or incorrect)
                    if dragOffset.width > 0 {
                        Color.green.opacity(Double(swipeOpacity * 0.10))
                    } else if dragOffset.width < 0 {
                        Color.red.opacity(Double(swipeOpacity * 0.10))
                    }
                }
                .ignoresSafeArea()
            )
            .navigationTitle("Study Mode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showEndStudyModeConfirmation = true
                    }label: {
                        Image(systemName: SFSymbols.xmark)
                            .foregroundStyle(AppInfo.actionButtonTintColor)
                    }
                }
            }
            .alert("Are you sure you want to end study mode?", isPresented: $showEndStudyModeConfirmation) {
                Button("Yes", role: .destructive) {
                   dismiss()
                }
                Button("Cancel", role: .cancel) { }
            }message: {
                Text("You will lose your current progress if you stop right now")
            }
            .background(
                AppInfo.backgroundColor.ignoresSafeArea()
            )
        }
    }
    
    private func swipe(direction: CGFloat) {
        // Slide current card offscreen
        let offscreenX = direction * 800.0
        withAnimation(.easeInOut(duration: 0.25)) {
            dragOffset = CGSize(width: offscreenX, height: 0)
        }
        
        // Animate next card blur to clear
        withAnimation(.easeInOut(duration: 0.35)) {
            nextCardBlur = 0.0
        }
        
        withAnimation(.easeOut(duration: 0.25)) {
            swipeOpacity = 0     // smooth fade-out
        }
        
        // After the animation, reveal the next card
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            if currentCardIndex < language.stickies.count - 1 {
                currentCardIndex += 1
            } else {
                // end of deck, show stats screen etc..
                
                dismiss()
            }
            dragOffset = .zero
            nextCardBlur = 4.0
        }
    }
}
