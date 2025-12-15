//
//  DecksListView.swift
//  Stickies
//
//  Created by Chris W on 11/21/25.
//

import SwiftUI

struct DecksListView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var language: Language
    @State private var decksSnapshot: [Deck] = []
    
    @State private var showNewDeckView = false
    @State private var showCalendarStreakView = false
    @State private var isEditing = false
    @State private var deckToDelete: Deck? = nil
    @State private var showDeckDeleteConfirmation = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    NavTitleLanguageHeader(name: language.name ?? "Language", image: language.image ?? popularLanguages[0].image)

                    if !decksSnapshot.isEmpty {
                        Text("\(language.unwrappedDecks.count) \(language.unwrappedDecks.count == 1 ? "Deck" : "Decks")")
                            .fontWeight(.regular)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(UIColor.lightGray))
                            .padding(.vertical, 4)
                    }
                    
                    LazyVGrid(columns: viewModel.gridColumns, spacing: 10) {
                        ForEach(decksSnapshot, id: \.id) { deck in
                            ZStack(alignment: .topTrailing) {
                                //Deck detail navigation to show stickies in the deck
                                NavigationLink(value: Route.deckDetail(deck)) {
                                    DeckCardView(deck: deck)
                                }
                                .buttonStyle(.plain)

                                
                                ZStack {
                                    //Delete button shown in editing
                                    if isEditing {
                                        Button {
                                            deckToDelete = deck
                                            showDeckDeleteConfirmation = true
                                        }label: {
                                            Image(systemName: SFSymbols.xmarkAppFill)
                                                .font(.system(size: 22))
                                                .foregroundColor(.red)
                                                .padding(6)
                                            
                                        }
                                    }
                                }
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 0.25), value: isEditing)
                            }
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.25), value: decksSnapshot.count)
                    .onAppear { decksSnapshot = language.unwrappedDecks }
                    .onChange(of: language.unwrappedDecks) { //snapshot needed for proper animation
                        withAnimation(.easeInOut(duration: 0.25)) {
                            decksSnapshot = language.unwrappedDecks
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .scrollIndicators(.hidden)
            
            if decksSnapshot.isEmpty {
                CustomContentUnavailableView(label: "No decks yet", image: AppInfo.sadCharacter, description: "To get started, tap the + new deck button")
                .animation(.easeInOut(duration: 0.3), value: decksSnapshot)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button {
                    showNewDeckView = true
                }label: {
                    Text("+ New Deck")
                        .fontWeight(.medium)
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: 54)  // makes it stretch to the container width
                .padding()
                .buttonStyle(DepthButtonStyle(
                    foregroundColor: AppInfo.actionButtonTintColor,
                    backgroundColor: AppInfo.mainTintColor))
            }
            .padding(.top, 4)
            .padding(.bottom, 4)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isEditing.toggle()
                    }
                }
                
                Button {
                    showCalendarStreakView = true
                }label: {
                    Image(systemName: SFSymbols.calendar)
                }
                .buttonStyle(.bordered)
                .tint(AppInfo.mainTintColor)
            }
        }
        .background(
            AppInfo.backgroundColor.ignoresSafeArea()
        )
        .fullScreenCover(isPresented: $showNewDeckView) {
            NewDeckView(language: language)
        }
        .sheet(isPresented: $showCalendarStreakView) {
            CalendarStreakView()
                .presentationDetents([.large])
        }
        .alert(deckToDelete != nil ? "Are you sure you want to delete \(deckToDelete?.name ?? "Name")?" : "Are you sure you want to delete this deck?", isPresented: $showDeckDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                //Delete language
                if let deck = deckToDelete {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        viewModel.deleteDeck(for: language, deck: deck)
                    }
                    deckToDelete = nil
                }
            }
            Button("Cancel", role: .cancel) {
                deckToDelete = nil
            }
        }message: {
            Text("Deleting this deck will also remove all of your sticky flashcards associated with it.")
        }
    }
}
