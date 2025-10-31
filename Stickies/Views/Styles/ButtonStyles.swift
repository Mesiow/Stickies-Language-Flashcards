//
//  ButtonStyles.swift
//  Stickies
//
//  Created by Chris W on 10/30/25.
//

import SwiftUI

struct DepthButtonStyle: ButtonStyle {
    let foregroundColor: Color
    let backgroundColor: Color
    let offset: CGFloat = 4
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(backgroundColor)
                .offset(y: offset)
            
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(foregroundColor)
                .offset(y: configuration.isPressed ? offset : 0)
            
            configuration.label
                .offset(y: configuration.isPressed ? offset : 0)
        }
    }
}
