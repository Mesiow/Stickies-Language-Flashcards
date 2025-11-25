//
//  NewDeckView.swift
//  Stickies
//
//  Created by Chris W on 11/21/25.
//

import SwiftUI

struct NewDeckView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var language: Language
    var existingDeck: Deck?
    
    @State private var name: String = ""
    @State private var desc: String = ""
    @State private var color: Color = AppInfo.stickyNoteTintColor
    
    @State private var showNameAlreadyExistsAlert = false
    @State private var showNameIsEmptyAlert = false
    @FocusState private var isNameFocused: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 24) {
                    Spacer()
                        .frame(height: 40)
                    
                    ZStack {
                        // Sticky note background
                        StickyNoteStyleView()
                        
                        VStack(alignment: .center, spacing: 14) {
                            HStack {
                                Spacer()
                                TextField("Deck name", text: $name)
                                    .focused($isNameFocused)
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundStyle(.black)
                                    .multilineTextAlignment(.center)
                                    .textFieldStyle(.plain)
                                Spacer()
                            }
                            
                            fieldDivider()
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 36)
                        .tint(AppInfo.mainTintColor)
                    }
                    .frame(maxWidth: .infinity, minHeight: 350, maxHeight: 350)
                    .padding(.horizontal, 6)
                   
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Create Deck")
            .scrollDismissesKeyboard(.interactively)
            .scrollIndicators(.hidden)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    }label: {
                        Image(systemName: SFSymbols.xmark)
                            .foregroundStyle(AppInfo.actionButtonTintColor)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button {
                        createDeck()
                    }label: {
                        Text("Create")
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
            .background(
                AppInfo.backgroundColor.ignoresSafeArea()
            )
            .alert("Deck name already exsists, choose another name", isPresented: $showNameAlreadyExistsAlert) {
                Button("Ok", role: .cancel) { }
            }
            .alert("Deck name is empty", isPresented: $showNameIsEmptyAlert) {
                Button("Ok", role: .cancel) { }
            }message: {
                Text("You must enter a name for your deck")
            }
            .onAppear {
                isNameFocused = true
            }
        }
    }
    
    func createDeck(){
        //Check if deck name is empty
        guard !name.isEmpty else {
            showNameIsEmptyAlert = true
            return
        }
        
        //Check if deck name already exists
        let nameExists = language.decks.filter { $0.name == name }.count > 0
        guard !nameExists else {
            showNameAlreadyExistsAlert = true
            return
        }
        
        let deck = Deck(language: language, name: name)
        homeViewModel.addNewDeck(for: language, deck: deck)
        
        dismiss()
    }
}
