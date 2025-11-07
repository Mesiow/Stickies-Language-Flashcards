//
//  StickiesListView.swift
//  Stickies
//
//  Created by Chris W on 10/29/25.
//

import SwiftUI

struct StickiesListView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var language: Language
    
    @State private var showNewStickyView = false
    @State private var stickyCardToEdit: Sticky?
    @State private var isEditing = false
    
    //1 column for all items
    let gridColumns = [
        GridItem(.flexible())
    ]
    
  
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Text("\(language.stickies.count) Sticky Notes")
                        .fontWeight(.regular)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(UIColor.lightGray))
                    
                    LazyVGrid(columns: gridColumns, spacing: 10) {
                        ForEach(language.stickies, id: \.id) { sticky in
                            ZStack(alignment: .leading) {
                                //Delete button shown in editing
                                if isEditing {
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            viewModel.deleteSticky(for: language, sticky: sticky)
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
                                    .animation(.easeInOut(duration: 0.25), value: isEditing)
                                    .onTapGesture {
                                        if !isEditing {
                                            stickyCardToEdit = sticky
                                        }
                                    }
                            }
                            .animation(.easeInOut(duration: 0.25), value: isEditing)
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 4)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle(language.name)
        .safeAreaInset(edge: .bottom) {
            Button {
                // start study mode
            }label: {
                Text("Begin Study")
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
        .background(
            AppInfo.secondaryTintColor.opacity(0.35).ignoresSafeArea()
        )
        .fullScreenCover(isPresented: $showNewStickyView) {
            NewStickyCardView(language: language)
        }
        .fullScreenCover(item: $stickyCardToEdit) { sticky in
            NewStickyCardView(language: language, existingSticky: sticky)
        }
    }
}
