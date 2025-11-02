//
//  StickiesListView.swift
//  Stickies
//
//  Created by Chris W on 10/29/25.
//

import SwiftUI

struct StickiesListView: View {
    
    @EnvironmentObject private var navigationModel: NavigationModel
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var language: Language
    
    //1 column for all items
    let gridColumns = [
        GridItem(.flexible())
    ]
    
    var exampleWords: [Sticky] {
        return [
            Sticky(language: Language(code: "es", name: "Spanish", image: "es-Spain"),foreignWord: "Buenos Dias", translation: "Good Morning"),
            Sticky(language: Language(code: "es", name: "Spanish", image: "es-Spain"), foreignWord: "Hola", translation: "Hello/Hi"),
            Sticky(language: Language(code: "es", name: "Spanish", image: "es-Spain"), foreignWord: "Encontrar", translation: "To Find")
        ]
    }
    
  
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Text("\(exampleWords.count) Sticky Notes")
                        .fontWeight(.regular)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(UIColor.lightGray))
                    
                    LazyVGrid(columns: gridColumns, spacing: 10) {
                        ForEach(exampleWords, id: \.self) { sticky in
                            StickyNoteCardView(sticky: sticky)
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
            .frame(maxWidth: .infinity, maxHeight: 44)  // makes it stretch to the container width
            .padding()
            .buttonStyle(DepthButtonStyle(
                foregroundColor: AppInfo.actionButtonTintColor,
                backgroundColor: AppInfo.actionButtonBackgroundTintColor))
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    navigationModel.push(.addNewSticky)
                }label: {
                    Image(systemName: SFSymbols.plusCircleFill)
                        .foregroundStyle(AppInfo.actionButtonTintColor)
                }
            }
        }
        .background(
            AppInfo.secondaryTintColor.opacity(0.35).ignoresSafeArea()
        )
    }
}
