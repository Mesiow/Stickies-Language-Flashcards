//
//  StudyModeView.swift
//  Stickies
//
//  Created by Chris W on 11/11/25.
//

import SwiftUI

enum SwipeDirection {
    case left
    case right
}

struct StudyModeView: View {
    
    @StateObject private var viewModel = StudyModeViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var language: Language
    
    @State private var currentCardIndex: Int = 0
    @State private var dragOffset: CGSize = .zero
    @State private var nextCardBlur: CGFloat = 4.0 // control blur of next card to show
    @State private var swipeOpacity: Double = 0 //controls tint and showing of checkmark/xmark when swiping
    let swipeThreshold: CGFloat = 150.0 //the threshold the card needs to reach on a swipe to be a successful swipe
    
    //Float for the progress bar
    var progress: CGFloat {
        guard language.stickies.count > 0 else { return 0 }
        return CGFloat(currentCardIndex + 1) / CGFloat(language.stickies.count)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 60)
                
                VStack(alignment: .center) {
                    Text("Sticky \(currentCardIndex + 1) \\ \(language.stickies.count)")
                        .foregroundStyle(Color(UIColor.lightGray))
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    ProgressView(value: progress)
                        .frame(width: 200)
                        .progressViewStyle(.linear)
                        .tint(AppInfo.mainTintColor)
                        .animation(.easeInOut(duration: 0.25), value: progress)
                }
                .padding(.vertical, 4)
                
                ZStack{
                    if !language.stickies.isEmpty {
                        //Next card underneath current card
                        if currentCardIndex < language.stickies.count - 1 {
                            let nextSticky = language.stickies[currentCardIndex + 1]
                            
                            StickyNoteStyleView()
                                .padding(.horizontal, 25)
                                .overlay(
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
                                    .blur(radius: nextCardBlur)
                                )
                                .animation(.easeInOut(duration: 0.3), value: nextCardBlur)
                        }
                        
                        ZStack {
                            //Current top card
                            StickyNoteStyleView()
                                .padding(.horizontal, 25)
                            
                            let sticky = language.stickies[currentCardIndex]
                            
                            VStack {
                                Text(sticky.foreignWord)
                                    .font(.system(size: 32, weight: .semibold))
                                    .foregroundStyle(.black)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                Text("Tap To Reveal")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(.gray)
                                    .opacity(0.8)
                                    .padding(.top, 4)
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
                        .onTapGesture {
                            #warning("TODO implement tap gesture for showing translation")
                            print("sticky tapped")
                        }
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
        //Stats logic
        if direction == .right {
            viewModel.correctCount += 1
        }else if direction == .left {
            viewModel.incorrectCount += 1
        }
        
        //-- Swipe animation logic --
        
        // Slide current card offscreen
        let multiplier: CGFloat = direction == .right ? 1 : -1
        let offscreenX = multiplier * 800.0
        
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
            //Reset for next card
            if currentCardIndex < language.stickies.count - 1 {
                currentCardIndex += 1
                
                dragOffset = .zero
                nextCardBlur = 4.0
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
