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
                if languages.isEmpty {
                    VStack(spacing: 12) {
                        Spacer(minLength: 0) // ensures it starts below nav/title
                        ContentUnavailableView {
                            Label{
                                Text("No languages yet")
                                    .foregroundStyle(.primary)
                            }icon: {
                                Image("icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }description: {
                            Text("To get started, tap the + add button to add a language")
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                    }
                    .allowsHitTesting(false)
                    .ignoresSafeArea(edges: [.horizontal, .bottom]) // don't ignore top
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: languages)
                    .background(Color.clear) // no background covering the nav
                    
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
                HStack {
                    Spacer()
                    Button {
                        navigationModel.push(.addLanguage)
                    } label: {
                        Image(systemName: SFSymbols.plus)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(AppInfo.secondaryTintColor)
                            .frame(width: 56, height: 56)
                            .background(AppInfo.mainTintColor)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .padding(.trailing, 32)
                    .padding(.bottom, 32)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(viewModel.isEditing ? "Done" : "Edit") {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            viewModel.isEditing.toggle()
                        }
                    }
                    .tint(.black)
                    
                    Button {
                        
                    }label: {
                        Image(systemName: SFSymbols.ellipseCircle)
                    }
                    .tint(.black)
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
