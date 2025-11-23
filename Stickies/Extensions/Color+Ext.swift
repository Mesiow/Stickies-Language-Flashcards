//
//  Color+Ext.swift
//  Stickies
//
//  Created by Chris W on 11/23/25.
//

import SwiftUI

extension Color {
    func darken(by percentage: CGFloat = 0.25) -> Color {
        let uiColor = UIColor(self)

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)

        return Color(
            red: max(r - percentage, 0),
            green: max(g - percentage, 0),
            blue: max(b - percentage, 0),
            opacity: Double(a)
        )
    }
}
