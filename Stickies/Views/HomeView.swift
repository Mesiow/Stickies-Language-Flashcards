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
            ScrollView {
                LazyVGrid(columns: viewModel.gridColumns, spacing: 2) {
                    ForEach(languages, id: \.id) { lang in
                        NavigationLink(value: Route.languageStickiesView(lang)) {
                            LanguageCardView(language: lang)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Languages")
            .navigationDestination(for: Route.self) { route in
                //Navigate to route
                switch route {
                    case .addLanguage:
                        AddLanguageView()
                    
                    case .languageStickiesView(let lang):
                        StickiesListView(language: lang)
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
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.isEditing.toggle()
                        }
                    }
                    
                    Button {
                        
                    }label: {
                        Image(systemName: SFSymbols.ellipseCircle)
                    }
                }
            }
            .background(
                AppInfo.secondaryTintColor.opacity(0.35).ignoresSafeArea()
            )
        }
    }
}
