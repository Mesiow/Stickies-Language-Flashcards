//
//  NewStickyCardView.swift
//  Stickies
//
//  Created by Chris W on 11/1/25.
//

import SwiftUI

struct NewStickyCardView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var language: Language
    
    @State private var foreignWord: String = ""
    @State private var translation: String = ""
    @State private var exampleSentence: String = ""
    
    @State private var showInputAlert = false
    
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
                            TextField("Foreign word", text: $foreignWord)
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal)
                                .textFieldStyle(.plain)
                            
                            Divider()
                                .background(Color.black.opacity(0.15))
                            
                            TextField("Translation", text: $translation)
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(.black.opacity(0.85))
                                .padding(.horizontal)
                                .textFieldStyle(.plain)
                            
                            Divider()
                                .background(Color.black.opacity(0.15))
                            
                            TextEditor(text: $exampleSentence)
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.black.opacity(0.9))
                                .frame(height: 160)
                                .padding(.horizontal, 4)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .overlay(
                                    Text(exampleSentence.isEmpty ? "Example sentence (optional)" : "")
                                        .foregroundColor(.black.opacity(0.3))
                                        .font(.system(size: 18))
                                        .padding(.horizontal, 8)
                                        .padding(.top, 8),
                                    alignment: .topLeading
                                )
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 16)
                    }
                    .frame(maxWidth: .infinity, minHeight: 420, maxHeight: 450)
                    .padding(.horizontal, 6)
                    
                    Spacer()
                }
            }
            .navigationTitle("New Sticky")
            .navigationBarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.interactively)
            .padding(.horizontal)
            .safeAreaInset(edge: .bottom) {
                Button {
                    guard !foreignWord.isEmpty, !translation.isEmpty else {
                        showInputAlert = true
                        return
                    }
                    
                    //Add new sticky note card for the language and dismiss the view
                    let newSticky = Sticky(language: language, foreignWord: foreignWord, translation: translation, examplePhrase: exampleSentence)
                    viewModel.addNewSticky(for: language, sticky: newSticky)
                    
                    dismiss()
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
            .alert("Sticky Note Empty", isPresented: $showInputAlert) {
                Button("Ok", role: .cancel) { }
            }message: {
                Text("You must enter a word and translation before creating")
            }
            .background(
                AppInfo.secondaryTintColor.opacity(0.35).ignoresSafeArea()
            )
        }
    }
}
