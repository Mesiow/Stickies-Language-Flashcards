//
//  NewStickyCardView.swift
//  Stickies
//
//  Created by Chris W on 11/1/25.
//

import SwiftUI

func fieldDivider() -> some View {
    Divider()
        .frame(height: 1 / UIScreen.main.scale)
        .background(Color.black.opacity(0.15))
        .padding(.vertical, 4)
}


struct NewStickyCardView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = NewStickyCardViewModel()
    
    @Bindable var deck: Deck
    var existingSticky: Sticky?
    @FocusState private var isWordFocused: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    Spacer()
                        .frame(height: 40)
                    
                    ZStack {
                        // Sticky note background
                        StickyNoteStyleView()
                        
                        // Input fields layered on top
                        VStack(alignment: .leading, spacing: 14) {
                            TextField("Word", text: $viewModel.foreignWord)
                                .focused($isWordFocused)
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundStyle(.black)
                                .padding(.horizontal)
                                .textFieldStyle(.plain)
                            
                            fieldDivider()
                            
                            TextField("Translation", text: $viewModel.translation)
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(.black.opacity(0.85))
                                .padding(.horizontal)
                                .textFieldStyle(.plain)
                            
                            fieldDivider()
                            
                            TextField("Pronunciation", text: Binding(
                                get: { viewModel.pronunciation ?? "" },
                                set: { viewModel.pronunciation = $0.isEmpty ? nil : $0 }
                                ))
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(.black.opacity(0.85))
                                .padding(.horizontal)
                                .textFieldStyle(.plain)
                            
                            fieldDivider()
                            
                            TextEditor(text: Binding(
                                get: { viewModel.exampleSentence ?? "" },
                                set: { viewModel.exampleSentence = $0.isEmpty ? nil : $0 }
                                ))
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.black.opacity(0.9))
                                .frame(height: 160)
                                .padding(.horizontal, 4)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .overlay(
                                    Text(((viewModel.exampleSentence?.isEmpty) == nil) ? "Example sentence (optional)" : "")
                                        .foregroundColor(.black.opacity(0.3))
                                        .font(.system(size: 18))
                                        .padding(.horizontal, 8)
                                        .padding(.top, 8),
                                    alignment: .topLeading
                                )
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 16)
                        .tint(AppInfo.mainTintColor)
                    }
                    .frame(maxWidth: .infinity, minHeight: 420, maxHeight: 460)
                    .padding(.horizontal, 6)
                    
                    Spacer()
                }
            }
            .navigationTitle(existingSticky == nil ? "New Sticky" : "Edit Sticky")
            .navigationBarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.interactively)
            .scrollIndicators(.hidden)
            .padding(.horizontal)
            .safeAreaInset(edge: .bottom) {
                Button {
                    guard !viewModel.foreignWord.isEmpty, !viewModel.translation.isEmpty else {
                        viewModel.showInputAlert = true
                        return
                    }
                    
                    //Editing
                    if let existing = existingSticky {
                        homeViewModel.updateSticky(existing, foreignWord: viewModel.foreignWord, translation: viewModel.translation, pronunciation: viewModel.pronunciation, exampleSentence: viewModel.exampleSentence)
                    } else {
                        //Add new sticky note card for the language
                        let newSticky = Sticky(deck: deck, foreignWord: viewModel.foreignWord, translation: viewModel.translation, pronunciation: viewModel.pronunciation, examplePhrase: viewModel.exampleSentence)
                        homeViewModel.addNewSticky(for: deck, sticky: newSticky)
                    }
                    
                    dismiss()
                }label: {
                    Text(existingSticky == nil ? "Create" : "Save")
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
            .alert("Sticky Note Empty", isPresented: $viewModel.showInputAlert) {
                Button("Ok", role: .cancel) { }
            }message: {
                Text("You must enter a word and translation before creating")
            }
            .background(
                AppInfo.backgroundColor.ignoresSafeArea()
            )
            .onAppear {
                guard !viewModel.didLoadExisting else { return }
                viewModel.didLoadExisting = true
        
                if let existing = existingSticky {
                    viewModel.loadExisting(existingSticky: existing)
                }else {
                    //Focus textfield if new sticky
                    isWordFocused = true
                }
            }
        }
    }
}
