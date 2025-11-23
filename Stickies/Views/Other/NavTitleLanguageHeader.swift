//
//  NavTitleHeaderView.swift
//  Stickies
//
//  Created by Chris W on 11/23/25.
//

import SwiftUI

struct NavTitleLanguageHeader: View {
    
    let name: String
    let image: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(name)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                
                FlagImageView(image: image, width: 36, height: 26)
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.top, 4)
    }
}
