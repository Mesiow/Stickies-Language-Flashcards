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
    @State private var showEndStudyModeConfirmation = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 60)
                
                Text("\(currentCardIndex + 1) \\ \(language.stickies.count)")
                    .foregroundStyle(Color(UIColor.lightGray))
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                ZStack(alignment: .center){
                    StickyNoteStyleView()
                        .padding(.horizontal, 25)
                    
                    if !language.stickies.isEmpty {
                        let sticky = language.stickies[currentCardIndex]
                        Text(sticky.foreignWord)
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                }
                .frame(maxWidth: .infinity, minHeight: 360, maxHeight: 360)
                
                HStack {
                    Text("Swipe left\n if you don't know it")
                        .frame(maxWidth: .infinity)
                    
                    Text("Swipe right\n if you know it")
                        .frame(maxWidth: .infinity)
                }
                .foregroundStyle(.black.opacity(0.7))
                .font(.system(size: 14))
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                
                Spacer()
            }
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
        }
    }
}
