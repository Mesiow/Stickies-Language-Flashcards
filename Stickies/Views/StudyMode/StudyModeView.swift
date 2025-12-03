//
//  StudyModeView.swift
//  Stickies
//
//  Created by Chris W on 11/11/25.
//

import SwiftUI
import CoreHaptics

enum SwipeDirection {
    case left
    case right
}

struct StudyModeView: View {
    
    @StateObject private var viewModel = StudyModeViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var deck: Deck
    
    @State private var isCardFlipped: Bool = false
    @State private var currentCardIndex: Int = 0
    @State private var dragOffset: CGSize = .zero
    @State private var nextCardOpacity: CGFloat = 0.0
    @State private var swipeOpacity: Double = 0 //controls tint and showing of checkmark/xmark when swiping
    let swipeThreshold: CGFloat = 150.0 //the threshold the card needs to reach on a swipe to be a successful swipe
    
    //Float for the progress bar
    var progress: CGFloat {
        guard deck.sortedStickies.count > 0 else { return 0 }
        return CGFloat(currentCardIndex + 1) / CGFloat(deck.sortedStickies.count)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 60)
                
                VStack(alignment: .center) {
                    Text("Sticky \(currentCardIndex + 1) \\ \(deck.sortedStickies.count)")
                        .foregroundStyle(Color(UIColor.lightGray))
                        .font(.system(size: 18, design: .rounded))
                        .fontWeight(.medium)
                    
                    //Progress bar
                    ZStack(alignment: .leading) {
                        // OUTER capsule background
                        Capsule()
                            .fill(AppInfo.mainTintColor.opacity(0.25))
                            .frame(width: 220, height: 22)
                        
                        // INNER progress bar capsule
                        Capsule()
                            .fill(AppInfo.mainTintColor)
                            .frame(width: (220 - 12) * progress, height: 8)
                            .padding(.horizontal, 6)
                            
                    }
                    .animation(.easeInOut(duration: 0.25), value: progress)
                }
                .padding(.vertical, 4)
                
                ZStack{
                    if !deck.sortedStickies.isEmpty {
                        //Next card underneath current card
                        if currentCardIndex < deck.sortedStickies.count - 1 {
                            let nextSticky = deck.sortedStickies[currentCardIndex + 1]
                            
                            ZStack {
                                StickyNoteStyleView()
                                VStack {
                                    Text(nextSticky.foreignWord)
                                        .font(.system(size: 32, weight: .semibold))
                                        .foregroundStyle(.black)
                                        .padding(.horizontal)
                                    Text("Tap To Reveal")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(.gray)
                                        .opacity(0.8)
                                        .padding(.top, 4)
                                }
                                .multilineTextAlignment(.center)
                                .opacity(nextCardOpacity)
                                .animation(.easeInOut(duration: 0.3), value: nextCardOpacity)
                            }
                            .frame(maxWidth: .infinity, minHeight: 350, maxHeight: 350)
                            .padding(.horizontal, 25)
                        }
                        
                        //Sticky flashcard
                        ZStack {
                            ZStack {
                                let sticky = deck.sortedStickies[currentCardIndex]
                                if isCardFlipped {
                                    StickyBackCardView(sticky: sticky)
                                } else {
                                    StickyFrontCardView(sticky: sticky)
                                }
                            }
                            //Add rotation to only the card view to prevent swipe functionality from being inverted as well
                            .rotation3DEffect(
                                .degrees(isCardFlipped ? 180 : 0),
                                axis: (x: 0, y: 1, z: 0),
                                perspective: 0.25
                            )
                            .animation(.easeInOut(duration: 0.40), value: isCardFlipped)
                            .onTapGesture {
                                withAnimation {
                                    isCardFlipped.toggle()
                                }
                            }
                        }
                        .id(currentCardIndex)
                        .offset(x: dragOffset.width)
                        .rotationEffect(.degrees(Double(dragOffset.width / 25)))
                        .overlay(
                            ZStack {
                                // show X mark or checkmark icon when swiping
                                if dragOffset.width > 0 {
                                    Image(systemName: SFSymbols.checkmarkCircleFill)
                                        .font(.system(size: 60, weight: .bold))
                                        .foregroundStyle(.green.opacity(0.75))
                                        .opacity(swipeOpacity)
                                        .offset(y: -60)
                                        .padding()
                                } else if dragOffset.width < 0 {
                                    Image(systemName: SFSymbols.xmarkCircleFill)
                                        .font(.system(size: 60, weight: .bold))
                                        .foregroundStyle(.red.opacity(0.75))
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
                                        let direction: SwipeDirection = gesture.translation.width > 0 ? SwipeDirection.right : SwipeDirection.left //right or left
                                        swipe(direction)
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
                        viewModel.showEndStudyModeConfirmation = true
                    }label: {
                        Image(systemName: SFSymbols.xmark)
                            .foregroundStyle(AppInfo.actionButtonTintColor)
                    }
                }
            }
            .alert("Are you sure you want to end study mode?", isPresented: $viewModel.showEndStudyModeConfirmation) {
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
            .overlay(
                VStack {
                    if viewModel.showResults {
                        StudyModeCompletedStatisticsView(
                            correct: viewModel.correctCount,
                            incorrect: viewModel.incorrectCount,
                            onClose: {
                                //Apply decay after completing review
                                SRSManager.shared.applyDecay(to: deck.stickies)
                                withAnimation(.spring()) {
                                    viewModel.showResults = false
                                    dismiss()
                                }
                            }
                        )
                    }
                }
            )
        }
    }
    
    private func swipe(_ direction: SwipeDirection) {
        update(direction)
        slideCardOffscreen(direction)
    }
    
    //Update view model based on direction swiped
    private func update(_ direction: SwipeDirection){
        let currentSticky = deck.sortedStickies[currentCardIndex]
        //Stats logic
        if direction == .right {
            SRSManager.shared.markCorrect(currentSticky)
            viewModel.correctCount += 1
        }else if direction == .left {
            SRSManager.shared.markIncorrect(currentSticky)
            viewModel.incorrectCount += 1
        }
    }
    
    //Slide card animation when swiping
    private func slideCardOffscreen(_ direction: SwipeDirection){
        //-- Swipe animation logic --
        
        // Slide current card offscreen
        let multiplier: CGFloat = direction == .right ? 1 : -1
        let offscreenX = multiplier * 800.0
        
        withAnimation(.easeInOut(duration: 0.25)) {
            dragOffset = CGSize(width: offscreenX, height: 0)
        }
        
        // Animate next card blur to clear
        withAnimation(.easeInOut(duration: 0.35)) {
            nextCardOpacity = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.25)) {
            swipeOpacity = 0     // smooth fade-out
        }
        
        // After the animation, reveal the next card
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            //Reset for next card
            if currentCardIndex < deck.sortedStickies.count - 1 {
                currentCardIndex += 1
                
                dragOffset = .zero
                nextCardOpacity = 0.0
                isCardFlipped = false
            } else {
                // end of deck, show stats screen etc..
                showStudyModeStatsView()
            }
        }
    }
    
    private func showStudyModeStatsView(){
        withAnimation(.spring()) {
            viewModel.showResults = true
        }
    }
}
