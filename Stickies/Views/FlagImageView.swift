//
//  FlagImageView.swift
//  Stickies
//
//  Created by Chris W on 11/2/25.
//

import SwiftUI

struct FlagImageView: View {
    let image: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
    }
}
