//
//  PaywallManager.swift
//  Stickies
//
//  Created by Chris W on 12/16/25.
//

import SwiftUI
import Combine

enum PaywallReason {
    case addLanguageLimit
    case addDeckLimit
    case premiumFeature
}

@MainActor
final class PaywallManager: ObservableObject {
    static let shared = PaywallManager()

    @Published var isPaywallPresented: Bool = false
    @Published var reason: PaywallReason? = nil

    private init() {}

    func show(reason: PaywallReason) {
        self.reason = reason
        self.isPaywallPresented = true
    }

    func dismiss() {
        isPaywallPresented = false
        reason = nil
    }
}

