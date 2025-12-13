//
//  ReviewManager.swift
//  Invoice Maker
//
//  Created by Chris W on 8/20/25.
//

import SwiftUI
import StoreKit
import Combine

@MainActor
final class ReviewManager: ObservableObject {
    static let shared = ReviewManager()
    
    @AppStorage("reviewPromptActionCount") private var reviewActionCount = 0
    
    private init() { }
    
    func requestPositiveActionReview(everyNthTime: Int = 3) {
        let count = reviewActionCount
        //Ask for a review after every 3rd positive action if user has not already rated
        if count % everyNthTime == 0 {
            requestReview()
            //Reset when we hit 100
            if count >= 99 {
                reviewActionCount = 0
            }
        }
        
        //Update action count
        let actionCount = count + 1
        reviewActionCount = actionCount
    }
    
    private func requestReview() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if #available(iOS 16.0, *) {
                    AppStore.requestReview(in: windowScene)
                } else {
                    // Fallback on earlier versions
                    SKStoreReviewController.requestReview(in: windowScene)
                }
            }else {
                //If in app review fails to work, open the app for a review in the app store
                if let url = URL(string: "https://apps.apple.com/app/id\(AppInfo.id)?action=write-review") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}

