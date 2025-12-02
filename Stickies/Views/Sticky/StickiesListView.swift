//
//  StickiesListView.swift
//  Stickies
//
//  Created by Chris W on 10/29/25.
//

import SwiftUI

enum StrengthFilter {
    case all, weak, medium, strong
}

struct StickiesListView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var deck: Deck
    @State private var stickiesSnapshot: [Sticky] = []
    @State private var selectedFilter: StrengthFilter = .all
    
    @State private var showNewStickyView = false
    @State private var showStudyModeView = false
    @State private var stickyCardToEdit: Sticky?
    @State private var isEditing = false
    @State private var shuffleEnabled = false
    
    @State private var showNoStickiesExistAlert = false
    
    //1 column for all items
    let gridColumns = [
        GridItem(.flexible())
    ]
    
    private var sortedStickiesSnapshot: [Sticky] {
        deck.stickies.sorted { $0.createdAt < $1.createdAt }
    }
    
    private var mistakePoolActive: Bool {
        return deck.stickies.contains { sticky in
            sticky.isInMistakePool == true
        }
    }
    
    private var stickiesInMistakePool: [Sticky] {
        sortedStickiesSnapshot.filter { $0.isInMistakePool == true }
    }
    
  
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    //Filters
                    strengthFiltersView
                   
                    //Create new card button
                    CreateNewStickyCardView {
                        showNewStickyView = true
                    }
                    
                    if !deck.stickies.isEmpty {
                        RecentMistakesCardView(active: mistakePoolActive) {
                            //show recent mistakes view
                            navigationModel.push(.recentMistakesView(deck))
                        }
                    }
                    
                    Text("\(deck.stickies.count) \(deck.stickies.count == 1 ? "Sticky Card" : "Sticky Cards")")
                        .fontWeight(.regular)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(UIColor.lightGray))
                        .padding(.top, 4)
                    
                    LazyVGrid(columns: gridColumns, spacing: 10) {
                        ForEach(stickiesSnapshot, id: \.id) { sticky in
                            ZStack(alignment: .leading) {
                                //Delete button shown in editing
                                if isEditing {
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            viewModel.deleteSticky(for: deck, sticky: sticky)
                                        }
                                    }label: {
                                        Image(systemName: SFSymbols.xmarkAppFill)
                                            .font(.system(size: 22))
                                            .foregroundColor(.red)
                                            .padding(6)
                                        
                                    }
                                    .transition(.move(edge: .leading).combined(with: .opacity))
                                }
                                
                                StickyNoteCardView(sticky: sticky)
                                    .offset(x: isEditing ? 28 : 0)  // slide right when editing
                                    .onTapGesture {
                                        if !isEditing {
                                            stickyCardToEdit = sticky
                                        }
                                    }
                            }
                            .transition(.opacity)
                        }
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 4)
                    .animation(.easeInOut(duration: 0.25), value: stickiesSnapshot.count)
                    .onAppear {
                        stickiesSnapshot = sortedStickiesSnapshot
                        applyStrengthFilter()
                    }
                    .onChange(of: deck.stickies) { //snapshot needed for proper animation
                        withAnimation(.easeInOut(duration: 0.25)) {
                            stickiesSnapshot = sortedStickiesSnapshot
                            applyStrengthFilter()
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(deck.name)
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button {
                    //Only if stickies exist then we can practice
                    guard deck.stickies.count > 0 else {
                        showNoStickiesExistAlert = true
                        return
                    }
                    
                    // start study mode
                    showStudyModeView = true
                }label: {
                    Text("Review")
                        .fontWeight(.medium)
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: 54)  // makes it stretch to the container width
                .padding(.horizontal)
                .padding(.bottom)
                .buttonStyle(DepthButtonStyle(
                    foregroundColor: AppInfo.actionButtonTintColor,
                    backgroundColor: AppInfo.mainTintColor))
            }
            .background(AppInfo.stickyNoteTintColor.opacity(0.60))
            .ignoresSafeArea()
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isEditing.toggle()
                    }
                }
                
                Button {
                    showNewStickyView = true
                }label: {
                    Image(systemName: SFSymbols.plusCircleFill)
                        .foregroundStyle(AppInfo.actionButtonTintColor)
                }
            }
        }
        .alert("No Sticky Flashcards exist", isPresented: $showNoStickiesExistAlert) {
            Button("Ok", role: .cancel) { }
        }message: {
            Text("You have no sticky flashcards to study yet")
        }
        .background(
            AppInfo.backgroundColor.ignoresSafeArea()
        )
        .fullScreenCover(isPresented: $showNewStickyView) {
            NewStickyCardView(deck: deck)
        }
        .fullScreenCover(item: $stickyCardToEdit) { sticky in
            NewStickyCardView(deck: deck, existingSticky: sticky)
        }
        .fullScreenCover(isPresented: $showStudyModeView) {
            StudyModeView(deck: deck)
        }
        .onChange(of: selectedFilter) {
            withAnimation(.easeInOut(duration: 0.25)) {
                applyStrengthFilter()
            }
        }
        .onAppear {
            print("stickies list appeared")
            //Update strength of sticky flashcards based on last reviewed date
            SRSManager.shared.applyDecay(to: deck.stickies)
        }
    }
    
    //Strength Filters
    var strengthFiltersView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                StrengthPillView(
                    title: "All",
                    isSelected: selectedFilter == .all,
                    strengthLevel: .none
                ) {
                    selectedFilter = .all
                }
                
                StrengthPillView(
                    title: "Weak",
                    isSelected: selectedFilter == .weak,
                    strengthLevel: .weak
                ) {
                    selectedFilter = .weak
                }
                
                StrengthPillView(
                    title: "Medium",
                    isSelected: selectedFilter == .medium,
                    strengthLevel: .moderate
                ) {
                    selectedFilter = .medium
                }
                
                StrengthPillView(
                    title: "Strong",
                    isSelected: selectedFilter == .strong,
                    strengthLevel: .strong
                ) {
                    selectedFilter = .strong
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
        }
    }
    
    private func applyStrengthFilter() {
        let all = sortedStickiesSnapshot

        switch selectedFilter {
        case .all:
            stickiesSnapshot = all

        case .weak:
            stickiesSnapshot = all.filter {
                SRSManager.shared.strengthLevel(for: $0) == .weak
            }

        case .medium:
            stickiesSnapshot = all.filter {
                SRSManager.shared.strengthLevel(for: $0) == .moderate
            }

        case .strong:
            stickiesSnapshot = all.filter {
                SRSManager.shared.strengthLevel(for: $0) == .strong
            }
        }
    }
}
