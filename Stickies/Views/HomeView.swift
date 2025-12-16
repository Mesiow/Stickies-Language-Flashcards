//
//  ContentView.swift
//  Stickies
//
//  Created by Chris W on 10/28/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject private var navigationModel: NavigationModel

    @Query private var languages: [Language]
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: viewModel.gridColumns, spacing: 10) {
                        ForEach(languages, id: \.id) { lang in
                            ZStack(alignment: .topTrailing) {
                                NavigationLink(value: Route.languageDecksView(lang)) {
                                    LanguageCardView(language: lang)
                                }
                                .buttonStyle(.plain)
                                
                                ZStack {
                                    //Delete button shown in editing
                                    if viewModel.isEditing {
                                        Button {
                                            viewModel.languageToDelete = lang
                                            viewModel.showDeleteLangConfirmation = true
                                        }label: {
                                            Image(systemName: SFSymbols.xmarkAppFill)
                                                .font(.system(size: 22))
                                                .foregroundColor(.red)
                                                .padding(6)
                                            
                                        }
                                    }
                                }
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 0.25), value: viewModel.isEditing)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                }
                .scrollIndicators(.hidden)
                
                if languages.isEmpty {
                    CustomContentUnavailableView(label: "No languages yet", image: AppInfo.sadCharacter, description: "To get started, tap the + add button to add a language")
                        .animation(.easeInOut(duration: 0.3), value: languages)
                }
            }
            .navigationTitle("Languages")
            .navigationDestination(for: Route.self) { route in
                //Navigate to route
                switch route {
                    case .addLanguage:
                        AddLanguageView(existingLanguages: languages)
                    
                    case .languageDecksView(let lang):
                        DecksListView(language: lang)
                    
                    case .deckDetail(let deck):
                        StickiesListView(deck: deck)
                    
                    case .recentMistakesView(let deck):
                        RecentMistakesListView(deck: deck)
                }
            }
            .safeAreaInset(edge: .bottom) { //add button into safe area so that we dont block the last grid item
                //Add Item Button
                /*HStack {
                    Spacer()
                    Button {
                        navigationModel.push(.addLanguage)
                    } label: {
                        Image(systemName: SFSymbols.plus)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 56, height: 56)
                    .buttonStyle(
                        DepthCircleButtonStyle(
                            foregroundColor: AppInfo.actionButtonTintColor,
                            backgroundColor: AppInfo.mainTintColor
                        )
                    )
                    .padding(.trailing, 32)
                    .padding(.bottom, 32)
                }*/
                VStack {
                    Button {
                        navigationModel.push(.addLanguage)
                    }label: {
                        Text("+ New Language")
                            .font(.system(size: 20, weight: .bold))
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
                    Button(viewModel.isEditing ? "Done" : "Edit") {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            viewModel.isEditing.toggle()
                        }
                    }
                }
            }
            .alert(viewModel.languageToDelete != nil ? "Are you sure you want to delete \(viewModel.languageToDelete?.name ?? "Name")?" : "Are you sure you want to delete this language?", isPresented: $viewModel.showDeleteLangConfirmation) {
                Button("Delete", role: .destructive) {
                    //Delete language
                    if let language = viewModel.languageToDelete {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            viewModel.deleteLanguage(language)
                        }
                        viewModel.languageToDelete = nil
                    }
                }
                Button("Cancel", role: .cancel) {
                    viewModel.languageToDelete = nil
                }
            }message: {
                Text("Deleting this language will also remove all of your decks & sticky flashcards associated with it.")
            }
            .background(
                AppInfo.backgroundColor.ignoresSafeArea()
            )
        }
    }
}

struct AddLanguageCard: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        }label: {
            VStack(spacing: 12) {
                Image(systemName: SFSymbols.plus)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(.black.opacity(0.85))
                
                Text("Add Language")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.black.opacity(0.80))
            }
            .frame(maxWidth: .infinity, maxHeight: 170)
            .padding()
        }
        .buttonStyle(DepthButtonStyle(
            foregroundColor: AppInfo.stickyNoteTintColor,
            backgroundColor: AppInfo.stickyNoteBackgroundTintColor))
    }
}
