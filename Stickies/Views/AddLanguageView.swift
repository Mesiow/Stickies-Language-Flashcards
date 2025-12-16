//
//  AddLanguageView.swift
//  Stickies
//
//  Created by Chris W on 10/28/25.
//

import SwiftUI

struct AddLanguageView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject private var paywall: PaywallManager
    
    @State private var searchText = ""
    @State private var showLanguageAlreadyExistsAlert = false
    
    var existingLanguages: [Language]
    
    var filteredLanguages: [LanguageItem] {
        if searchText.isEmpty { return viewModel.languages}
        return viewModel.languages.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        ZStack {
            AppInfo.backgroundColor.ignoresSafeArea()
            List(filteredLanguages) { lang in
                Button(action: {
                    //Check if language already added
                    let doesntExist = existingLanguages.filter { $0.code == lang.code && $0.name == lang.name }.count <= 0
                    guard doesntExist else {
                        showLanguageAlreadyExistsAlert = true
                        return
                    }
                    
                    guard PremiumManager.shared.canAddLanguage(currentCount: existingLanguages.count) else {
                        paywall.show(reason: .addLanguageLimit)
                        return
                    }
                    
                    let languageSelected = Language(code: lang.code, name: lang.name, image: lang.image)
                    viewModel.addLanguage(languageSelected)
                    
                    dismiss()
                }) {
                    HStack(spacing: 12) {
                        FlagImageView(image: lang.image, width: 46, height: 36)
                        Text(lang.name)
                            .font(.headline)
                            .foregroundStyle(.gray)
                    }
                    .padding(.vertical, 6)
                }
            }
            .listStyle(.insetGrouped)
            .animation(.easeInOut(duration: 0.25), value: filteredLanguages)
        }
        .searchable(text: $searchText, prompt: "Search languages")
        .navigationTitle("Add Language")
        .navigationBarTitleDisplayMode(.inline)
        .alert("You have already added this language to your list", isPresented: $showLanguageAlreadyExistsAlert) {
            Button("Ok", role: .cancel) { }
        }
    }
}
