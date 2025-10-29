//
//  StickiesListView.swift
//  Stickies
//
//  Created by Chris W on 10/29/25.
//

import SwiftUI

struct StickiesListView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var language: Language
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .navigationTitle(language.name)
    }
}
