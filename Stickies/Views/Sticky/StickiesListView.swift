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
    
    private var mistakePoolActive: Bool {
        return deck.unwrappedStickies.contains { sticky in
            sticky.isInMistakePool == true
        }
    }
    
    private var stickiesInMistakePool: [Sticky] {
        deck.sortedStickies.filter { $0.isInMistakePool == true }
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
                    
                    //Show recent mistakes view & number of cards if not empty
                    if !deck.unwrappedStickies.isEmpty {
                        RecentMistakesCardView(active: mistakePoolActive) {
                            //show recent mistakes view
                            navigationModel.push(.recentMistakesView(deck))
                        }
                        
                        Text("\(stickiesSnapshot.count) \(stickiesSnapshot.count == 1 ? "Sticky Card" : "Sticky Cards")")
                            .fontWeight(.regular)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(UIColor.lightGray))
                            .padding(.top, 4)
                            .transition(.opacity)
                    }else {
                        //Empty
                        CustomContentUnavailableView(label: "No sticky flashcards yet", image: AppInfo.sadCharacter, description: "To get started, tap the + create new sticky button above")
                        .animation(.easeInOut(duration: 0.3), value: stickiesSnapshot)
                    }
                    
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
                        stickiesSnapshot = deck.sortedStickies
                        applyStrengthFilter()
                    }
                    .onChange(of: deck.unwrappedStickies) { //snapshot needed for proper animation
                        withAnimation(.easeInOut(duration: 0.25)) {
                            stickiesSnapshot = deck.sortedStickies
                            applyStrengthFilter()
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(deck.name ?? "Deck")
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button {
                    //Only if stickies exist then we can practice
                    guard deck.unwrappedStickies.count > 0 else {
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
                    Image(systemName: SFSymbols.plus)
                }
                .buttonStyle(.bordered)
                .tint(AppInfo.mainTintColor)
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
            StudyModeView(deck: deck, selectedStrengthFilter: selectedFilter)
        }
        .onChange(of: selectedFilter) {
            withAnimation(.easeInOut(duration: 0.25)) {
                applyStrengthFilter()
            }
        }
        .onAppear {
            print("stickies list appeared")
            //Update strength of sticky flashcards based on last reviewed date
            SRSManager.shared.applyDecay(to: deck.unwrappedStickies)
        }
    }
    
    //Strength Filters
    var strengthFiltersView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                StrengthPillView(
                    title: "All",
                    isSelected: selectedFilter == .all,
                    strengthLevel: .none,
                    active: true
                ) {
                    selectedFilter = .all
                }
                
                StrengthPillView(
                    title: "Weak",
                    isSelected: selectedFilter == .weak,
                    strengthLevel: .weak,
                    active: isCardAvailable(for: .weak)
                ) {
                    selectedFilter = .weak
                }
                
                StrengthPillView(
                    title: "Medium",
                    isSelected: selectedFilter == .medium,
                    strengthLevel: .moderate,
                    active: isCardAvailable(for: .moderate)
                ) {
                    selectedFilter = .medium
                }
                
                StrengthPillView(
                    title: "Strong",
                    isSelected: selectedFilter == .strong,
                    strengthLevel: .strong,
                    active: isCardAvailable(for: .strong)
                ) {
                    selectedFilter = .strong
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
        }
    }
    
    private func applyStrengthFilter() {
        let all = deck.sortedStickies

        switch selectedFilter {
        case .all:
            stickiesSnapshot = all

        case .weak:
            stickiesSnapshot = SRSManager.shared.filter(all, by: .weak)
           
        case .medium:
            stickiesSnapshot = SRSManager.shared.filter(all, by: .moderate)
        
        case .strong:
            stickiesSnapshot = SRSManager.shared.filter(all, by: .strong)
        }
    }
    
    //returns true or false if there are any cards with this strength level
    private func isCardAvailable(for level: StrengthLevel) -> Bool {
        return deck.unwrappedStickies.contains { sticky in
            SRSManager.shared.strengthLevel(for: sticky) == level
        }
    }
}
