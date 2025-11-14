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
    
    @State private var searchText = ""
    
    var filteredLanguages: [LanguageItem] {
        if searchText.isEmpty { return viewModel.languages}
        return viewModel.languages.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        ZStack {
            AppInfo.backgroundColor.ignoresSafeArea()
            List(filteredLanguages) { lang in
                Button(action: {
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
        }
        .searchable(text: $searchText, prompt: "Search languages")
        .navigationTitle("Add Language")
        .navigationBarTitleDisplayMode(.inline)
    }
}
