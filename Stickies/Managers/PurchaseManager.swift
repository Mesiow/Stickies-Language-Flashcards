import Foundation
import StoreKit
import Combine

@MainActor
class PurchaseManager: ObservableObject {
    
    enum PurchaseError: Error {
        case pending
        case failed
        case failedVerification
        case cancelled
        case notAllowed
    }
    
    var productIds: [String] = [
        "stickies_premium_yearly",
        "stickies_premium_monthly"
    ]
    @Published var productDetails: [PurchaseProductDetails] = []

    @Published var isSubscribed: Bool = false
    @Published var isPurchasing: Bool = false
    @Published var isFetchingProducts: Bool = false
    
    private var products: [Product] = [] //Storekit products
    private var updatesTask: Task<Void, Never>? //for transaction.updates listener
    
    init() {
        updatesTask = observeTransactionUpdates()
    }
    
    deinit {
        updatesTask?.cancel()
    }
    
    func loadProducts() async {
        isFetchingProducts = true
        defer { isFetchingProducts = false } //runs once the async method completes
        
        do {
            self.products = try await Product.products(for: productIds)
            
            //ensure in correct order
            let ordered: [Product] = productIds.compactMap { id in products.first(where: { $0.id == id }) }
            
            self.productDetails = ordered.map { product in
                 PurchaseProductDetails(
                    price: product.displayPrice,
                    productId: product.id,
                    duration: duration(for: product),
                    durationPlanName: planName(for: product),
                    hasTrial: product.hasFreeTrial,
                    isLifetimeOffer: product.isLifetimeOffer
                 )
            }
            await updatePurchasedProducts()
        }catch {
            print("Failed to fetch products")
        }
    }
    
    func updatePurchasedProducts() async {
        //Look at current entitlements for any of your product IDs
        var active = false
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            //User still has access
            if transaction.revocationDate == nil, productIds.contains(transaction.productID) {
                active = true
            }
        }
        isSubscribed = active
    }
    
    //This method runs in the background and is necessary for cases when the users purchase was interrupted (i.e billing information must be updated or phone died or apple terms must be accepted etc..) so that we can listen and finish the transaction if needed
    private func observeTransactionUpdates() -> Task<Void, Never> {
        //Run this task on its own thread as long as the app is running
        //to listen for updates and finish them
        Task.detached(priority: .background) { [weak self] in
            for await result in Transaction.updates {
                switch result{
                    case .verified(let transaction):
                        await transaction.finish()
                        await self?.updatePurchasedProducts()
                    
                    case .unverified:
                        print("Transaction Unverified")
                        
                }
            }
        }
    }
    
    func purchaseSubscription(productId: String) async {
        isPurchasing = true
        defer { isPurchasing = false }
        
        do {
            //Get the product
            if let product = products.first(where: { $0.id == productId }) {
                let result = try await product.purchase()
                
                switch result {
                case .pending:
                    throw PurchaseError.pending
                    
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction):
                        await transaction.finish()
                        await self.updatePurchasedProducts()
                        print("purchase success")
                        
                    case .unverified(_, let err):
                        print("Purchase Failed: \(err)")
                    }
                    
                case .userCancelled:
                    throw PurchaseError.cancelled
                    
                default:
                    throw PurchaseError.failed
                }
            }
        }catch {
            print("Error purchasing: \(error)")
        }
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            print("Restore failed:", error)
        }
    }
    
    //MARK: - Helpers
    private func planName(for product: Product) -> String {
        //Lifetime access, non consumable
        if product.subscription == nil && product.type == .nonConsumable {
            return "Lifetime Access"
        }
        
        //Has intro offer, return it
        if product.hasFreeTrial {
            if let offer = product.subscription?.introductoryOffer {
                return "\(offer.period.value)-Day Free Trial"
            }
        }
        
        guard let period = product.subscription?.subscriptionPeriod else {
            return "Subscription"
        }
        
        // Normalize 7-day period as weekly
        if period.unit == .day && period.value == 7 {
            return "Weekly"
        }
        
        // Human-friendly mapping for standard plans
        switch period.unit {
        case .week:  return "Weekly"
        case .month: return "Monthly"
        case .year:  return "Yearly"
        case .day:   return "Daily"
        @unknown default: return "Subscription"
        }
    }
    
    private func duration(for product: Product) -> String {
        
        //has intro offer, return it
        if product.hasFreeTrial {
            if let offer = product.subscription?.introductoryOffer {
                if offer.period.value == 3  {
                    return "week" //3 day free trial, then 4.99 per week
                }
            }
           
        }
        
        guard let period = product.subscription?.subscriptionPeriod else { return "" }
        
        // Normalize 7-day period as weekly
        if period.unit == .day && period.value == 7 {
            return "week"
        }
        
        // Only care about the unit, not the value
        switch period.unit {
        case .day:   return "day"
        case .week:  return "week"
        case .month: return "month"
        case .year:  return "year"
        @unknown default: return ""
        }
    }
}

// MARK: - Product helpers

private extension Product {
    var hasFreeTrial: Bool {
        // Intro offers may be .freeTrial or .payUpFront/.payAsYouGo
        guard let offer = subscription?.introductoryOffer else { return false }
        return offer.type == .introductory && offer.paymentMode == .freeTrial
    }
    
    var isLifetimeOffer: Bool {
        return subscription == nil && type == .nonConsumable
    }
}

class PurchaseProductDetails: ObservableObject, Identifiable {
    let id: UUID
    
    @Published var price: String
    @Published var productId: String
    @Published var duration: String
    @Published var durationPlanName: String
    @Published var hasTrial: Bool
    @Published var isLifetimeOffer: Bool
    
    init(price: String = "", productId: String = "", duration: String = "", durationPlanName: String = "", hasTrial: Bool = false, isLifetimeOffer: Bool = false) {
        self.id = UUID()
        self.price = price
        self.productId = productId
        self.duration = duration
        self.durationPlanName = durationPlanName
        self.hasTrial = hasTrial
        self.isLifetimeOffer = isLifetimeOffer
    }
    
}



