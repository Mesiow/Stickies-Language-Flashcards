//
//  StickyMascotView.swift
//  Stickies
//
//  Created by Chris W on 12/6/25.
//

import SwiftUI

struct StickyMascotView: View {
    var width: CGFloat = 100.0
    var height: CGFloat = 100.0
    let image: String
    let message: String?
    
    @State private var bounce: Bool = false
    
    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
                .scaleEffect(bounce ? 1 : 0.75)   // bounce animation
                .onAppear {
                    withAnimation(.spring(response: 0.50, dampingFraction: 0.45, blendDuration: 1.0)) {
                        bounce = true
                    }
                }
        }
    }
}
