//
//  PremiumManager.swift
//  Stickies
//
//  Created by Chris W on 12/15/25.
//

import SwiftUI
import Combine

@MainActor
final class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    private init() {}
    
    @Published private(set) var isPremium: Bool = false
    
    // MARK: - Free Tier Limits
    
    private let freeLanguageLimit = 1
    private let freeDeckLimit = 1

    func updateSubscriptionStatus(isSubscribed: Bool) {
        self.isPremium = isSubscribed
    }

    // MARK: - Feature Gates

    func canAddLanguage(currentCount: Int) -> Bool {
        isPremium || currentCount < freeLanguageLimit
    }

    func canAddDeck(currentCount: Int) -> Bool {
        isPremium || currentCount < freeDeckLimit
    }
}

