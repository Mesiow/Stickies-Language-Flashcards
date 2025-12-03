//
//  CustomContentUnavailableView.swift
//  Stickies
//
//  Created by Chris W on 12/3/25.
//

import SwiftUI

struct CustomContentUnavailableView: View {
    
    let label: String
    let image: String
    let description: String
    
    var body: some View {
        VStack(spacing: 6) {
            Spacer(minLength: 0) // ensures it starts below nav/title
            ContentUnavailableView {
                Label{
                    Text(label)
                        .foregroundStyle(.primary)
                }icon: {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            }description: {
                Text(description)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
        }
        .allowsHitTesting(false)
        .ignoresSafeArea(edges: [.horizontal, .bottom]) // don't ignore top
        .transition(.opacity)
        .background(Color.clear) // no background covering the nav
    }
}
