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

struct DepthCircleButtonStyle: ButtonStyle {
    let foregroundColor: Color
    let backgroundColor: Color
    let offset: CGFloat = 2
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            // BACK circle (shadow layer)
            Circle()
                .foregroundStyle(backgroundColor)
                .offset(y: offset)
            
            // FRONT circle (top layer)
            Circle()
                .foregroundStyle(foregroundColor)
                .offset(y: configuration.isPressed ? offset : 0)
            
            // BUTTON CONTENT
            configuration.label
                .offset(y: configuration.isPressed ? offset : 0)
        }
    }
}


//Solid yellow toolbar button with a black icon
extension View {
    func yellowToolbarButton() -> some View {
        self
            .buttonStyle(.borderedProminent)
            .tint(AppInfo.mainTintColor)
            .foregroundStyle(.black)
    }
}
