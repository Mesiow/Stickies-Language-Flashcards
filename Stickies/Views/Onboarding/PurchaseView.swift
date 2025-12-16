// PurchaseView SwiftUI
// Created by Adam Lyttle on 7/18/2024

// Make cool stuff and share your build with me:

//  --> x.com/adamlyttleapps
//  --> github.com/adamlyttleapps

// Special thanks:

//  --> Mario (https://x.com/marioapps_com) for recommending changes to fix
//      an issue Apple had rejecting the paywall due to excessive use of
//      the word "FREE"

import SwiftUI

struct PurchaseView: View {
    
    @EnvironmentObject private var purchaseModel: PurchaseManager
    
    @State private var shakeDegrees = 0.0
    @State private var shakeZoom = 0.9
    @State private var showCloseButton = false
    @State private var progress: CGFloat = 0.0

    @Binding var isPresented: Bool
    
    @State var showNoneRestoredAlert: Bool = false
    @State private var showTermsActionSheet: Bool = false

    @State private var freeTrial: Bool = true
    @State private var selectedProductId: String = ""
    
    let color: Color = Color(AppInfo.stickyNoteBackgroundTintColor)
    let icon: String = AppInfo.happyCharacter
    
    private let allowCloseAfter: CGFloat = 2.5 //time in seconds until close is allowed
    
    var hasCooldown: Bool = true
    
    private var hasTrialForSelection: Bool {
        let product = purchaseModel.productDetails.first(where: { $0.productId == selectedProductId })
        return product?.hasTrial ?? false
    }
    
    let placeholderProductDetails: [PurchaseProductDetails] = [
        PurchaseProductDetails(price: "-", productId: "demo", duration: "week", durationPlanName: "week", hasTrial: false),
        PurchaseProductDetails(price: "-", productId: "demo", duration: "week", durationPlanName: "week", hasTrial: false),
        PurchaseProductDetails(price: "-", productId: "demo", duration: "week", durationPlanName: "week", hasTrial: false)
    ]
    
    var callToActionText: String {
        if let selectedProductTrial = purchaseModel.productDetails.first(where: {$0.productId == selectedProductId})?.hasTrial {
            if selectedProductTrial {
                return "Start Free Trial"
            }
            else {
                return "Unlock Now"
            }
        }
        else {
            return "Unlock Now"
        }
    }
    
   /* var calculateFullPrice: Double? {
        if let weeklyPriceString = purchaseModel.productDetails.first(where: {$0.duration == "week"})?.price {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency

            if let number = formatter.number(from: weeklyPriceString) {
                let weeklyPriceDouble = number.doubleValue
                // Average weeks per year: 365 / 7 ≈ 52.1775
                return weeklyPriceDouble * (365.0 / 7.0)
            }
            
        }
        
        return nil
    }*/
    
    //Calculate full price from monthly
    var calculateFullPrice: Double? {
         if let monthlyPriceString = purchaseModel.productDetails.first(where: {$0.duration == "month"})?.price {
             let formatter = NumberFormatter()
             formatter.numberStyle = .currency

             if let number = formatter.number(from: monthlyPriceString) {
                 let monthlyPriceDouble = number.doubleValue
                 // Months per year: 12
                 return monthlyPriceDouble * 12.0
             }
             
         }
         
         return nil
     }
    
    var calculatePercentageSaved: Int {
        if let calculateFullPrice = calculateFullPrice, let yearlyPriceString = purchaseModel.productDetails.first(where: {$0.duration == "year"})?.price {
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency

            if let number = formatter.number(from: yearlyPriceString) {
                let yearlyPriceDouble = number.doubleValue
                
                let saved = Int(100 - ((yearlyPriceDouble / calculateFullPrice) * 100))
                
                if saved > 0 {
                    return saved
                }
                
            }
            
        }
        return 90
    }
    
    var body: some View {
        ZStack (alignment: .top) {

            ScrollView {
                HStack {
                    Spacer()
                    
                    if hasCooldown && !showCloseButton {
                        Circle()
                            .trim(from: 0.0, to: progress)
                            .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                            .opacity(0.1 + 0.1 * self.progress)
                            .rotationEffect(Angle(degrees: -90))
                            .frame(width: 20, height: 20)
                    }
                    else {
                        Image(systemName: "multiply")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, alignment: .center)
                            .clipped()
                            .onTapGesture {
                                isPresented = false
                            }
                            .opacity(0.2)
                    }
                }
                .padding(.top)
                .padding(.bottom, 2)
                .padding(.horizontal, 4)
                
                VStack (spacing: 6) {
                    
                    ZStack {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .scaleEffect(shakeZoom)
                            .rotationEffect(.degrees(shakeDegrees))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    startShaking()
                                }
                            }
                    }
                    Spacer()
                    VStack (spacing: 14) {
                        Text("Unlock Premium Access")
                            .font(.system(size: 30, weight: .semibold))
                            .multilineTextAlignment(.center)
                        VStack (alignment: .leading, spacing: 18) {
                            PurchaseFeatureView(title: "Unlimited Languages", desc: "Add as many languages as you need for studying", icon: SFSymbols.doc, color: color)
                            PurchaseFeatureView(title: "Unlimited Decks", desc: "Create as many decks as you want for each language", icon: SFSymbols.appGift, color: color)
                            PurchaseFeatureView(title: "Learn faster", desc: "Easy and simple review system helps you learn and remember more", icon: SFSymbols.tag, color: color)
                        }
                        .font(.system(size: 20))
                        .padding(.top, 4)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(AppInfo.backgroundColor)
                        )
                    }
                    
                    Spacer()
                    
                    VStack (spacing: 20) {
                        VStack (spacing: 14) {
                            
                            let productDetails = purchaseModel.isFetchingProducts ? placeholderProductDetails : purchaseModel.productDetails
                            
                            ForEach(productDetails) { productDetails in
                                
                                Button(action: {
                                    withAnimation {
                                        selectedProductId = productDetails.productId
                                    }
                                }) {
                                    VStack {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    let imageName = productDetails.isLifetimeOffer ? "infinity" : "goforward"
                                                    Image(systemName: imageName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 18, height: 18, alignment: .center)
                                                    .clipped()
                                                    .foregroundStyle(.gray)
                                                    
                                                    Text(productDetails.durationPlanName)
                                                        .font(.title3.bold())
                                                }
                                                if productDetails.hasTrial {
                                                    Text("then "+productDetails.price+" per "+productDetails.duration)
                                                        .opacity(0.8)
                                                }
                                                else {
                                                    HStack (spacing: 0) {
                                                        if let calculateFullPrice = calculateFullPrice, //round down
                                                           let calculateFullPriceLocalCurrency = toLocalCurrencyString(calculateFullPrice),
                                                           calculateFullPrice > 0
                                                        {
                                                            if productDetails.duration != "month" {
                                                                //shows the full price based on weekly calculaation
                                                                Text("\(calculateFullPriceLocalCurrency) ")
                                                                    .strikethrough()
                                                                    .opacity(0.4)
                                                                Text(" ")
                                                            }
                                                        }
                                                        
                                                        if productDetails.isLifetimeOffer {
                                                            Text(productDetails.price + " (one-time)")
                                                        }else {
                                                            Text(productDetails.price + " per " + productDetails.duration)
                                                        }
                                                    }
                                                    .opacity(0.8)
                                                }
                                            }
                                            Spacer()
                                            if productDetails.hasTrial || productDetails.duration == "month" {
                                                //removed: Some apps were being rejected with this caption present:
                                                /*Text("FREE")
                                                 .font(.title2.bold())*/
                                            }
                                            else  {
                                                VStack {
                                                    Text("SAVE \(calculatePercentageSaved)%")
                                                        .font(.caption.bold())
                                                        .foregroundStyle(.white)
                                                        .padding(8)
                                                }
                                                .background(Color.red)
                                                .cornerRadius(6)
                                            }
                                            
                                            ZStack {
                                                Image(systemName: (selectedProductId == productDetails.productId) ? "circle.fill" : "circle")
                                                    .foregroundStyle((selectedProductId == productDetails.productId) ? color : Color.primary.opacity(0.15))
                                                
                                                if selectedProductId == productDetails.productId {
                                                    Image(systemName: "checkmark")
                                                        .foregroundStyle(Color.white)
                                                        .scaleEffect(0.8)
                                                }
                                            }
                                            .font(.title3.bold())
                                            
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 16)
                                    }
                                    //.background(Color(.systemGray4))
                                    .frame(maxWidth: .infinity, minHeight: 75) // ensures minimum tappable height
                                    .cornerRadius(8)
                                    .overlay(
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke((selectedProductId == productDetails.productId) ? color : Color.primary.opacity(0.15), lineWidth: 1.5) // Border color and width
                                            RoundedRectangle(cornerRadius: 6)
                                                .foregroundStyle((selectedProductId == productDetails.productId) ? color.opacity(0.2) : Color.primary.opacity(0.001))
                                        }
                                    )
                                }
                                .tint(.none)
                                .accentColor(Color.primary)
                                
                            }
                            
                            /*HStack {
                                Toggle(isOn: Binding(
                                    get: { hasTrialForSelection },
                                    set: { enabled in
                                        // User wants a plan with (or without) trial.
                                        if enabled {
                                            // Prefer a plan with trial if you have it
                                            if let anyTrial = purchaseModel.productDetails.first(where: { $0.hasTrial }) {
                                                withAnimation { selectedProductId = anyTrial.productId }
                                            }
                                        } else {
                                            // Prefer yearly without trial; fall back to any non-trial.
                                            if let yearlyNoTrial = purchaseModel.productDetails.first(where: { !$0.hasTrial && $0.duration == "year" }) {
                                                withAnimation { selectedProductId = yearlyNoTrial.productId }
                                            } else if let anyNoTrial = purchaseModel.productDetails.first(where: { !$0.hasTrial }) {
                                                withAnimation { selectedProductId = anyNoTrial.productId }
                                            }
                                        }
                                    }
                                )) {
                                    Text("Free Trial Enabled")
                                        .font(.headline.bold())
                                }
                                .tint(.green)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                            }
                            .background(Color.primary.opacity(0.05))
                            .cornerRadius(6)*/
                            
                        }
                        .opacity(purchaseModel.isFetchingProducts ? 0 : 1)
                    }
                    .id("view-\(purchaseModel.isFetchingProducts)")
                    .background {
                        if purchaseModel.isFetchingProducts {
                            ProgressView()
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal)
        .safeAreaInset(edge: .bottom) {
            VStack (spacing: 6) {
                
                ZStack (alignment: .center) {
                    
                    ProgressView()
                        .opacity(purchaseModel.isPurchasing ? 1 : 0)
                    
                    Button(action: {
                        if !purchaseModel.isPurchasing {
                            Task {
                                await purchaseModel.purchaseSubscription(productId: self.selectedProductId)
                            }
                        }
                    }) {
                        HStack {
                            Text(callToActionText)
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .font(.title3.bold())
                    }
                    .opacity(purchaseModel.isPurchasing ? 0 : 1)
                    .frame(maxWidth: .infinity, maxHeight: 54)
                    .padding(.vertical, 8)
                    .buttonStyle(DepthButtonStyle(
                        foregroundColor: AppInfo.actionButtonTintColor,
                        backgroundColor: AppInfo.mainTintColor))
                    
                    
                }
                .padding(.horizontal)
                
                VStack (spacing: 5) {
                    HStack (spacing: 10) {
                        
                        Button("Restore") {
                            Task {
                                await purchaseModel.restorePurchases()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                                    if !purchaseModel.isSubscribed {
                                        showNoneRestoredAlert = true
                                    }
                                }
                            }
                        }
                        .alert(isPresented: $showNoneRestoredAlert) {
                            Alert(title: Text("Restore Purchases"), message: Text("No purchases restored"), dismissButton: .default(Text("OK")))
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray), alignment: .bottom
                        )
                        .font(.footnote)
                        
                        
                        Button("Terms of Use & Privacy Policy") {
                            showTermsActionSheet = true
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray), alignment: .bottom
                        )
                        .actionSheet(isPresented: $showTermsActionSheet) {
                            ActionSheet(title: Text("View Terms & Conditions"), message: nil,
                                        buttons: [
                                            .default(Text("Terms of Use"), action: {
                                                if let url = URL(string: AppInfo.termsUrl) {
                                                    UIApplication.shared.open(url)
                                                }
                                            }),
                                            .default(Text("Privacy Policy"), action: {
                                                if let url = URL(string: AppInfo.privacyPolicyUrl) {
                                                    UIApplication.shared.open(url)
                                                }
                                            }),
                                            .cancel()
                                        ])
                        }
                        .font(.footnote)
                        
                        
                    }
                    //.font(.headline)
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    
                    
                    
                    
                }
            }
            //.background(Color(UIColor.secondarySystemGroupedBackground))
            .opacity(purchaseModel.isFetchingProducts ? 0 : 1)
        }
        .onAppear {
            selectedProductId = purchaseModel.productIds.last ?? ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeIn(duration: allowCloseAfter)) {
                    self.progress = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + allowCloseAfter) {
                    withAnimation {
                        showCloseButton = true
                    }
                }
            }
        }
        .onChange(of: purchaseModel.isSubscribed) {
            if(purchaseModel.isSubscribed) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPresented = false
                    ReviewManager.shared.requestPositiveActionReview()
                }
            }
        }
        .onAppear {
            if(purchaseModel.isSubscribed) {
                isPresented = false
            }
        }
        .task {
            //Load all products
            Task {
                await purchaseModel.loadProducts()
            }
        }
        
        
    }
    
    private func startShaking() {
            let totalDuration = 0.7 // Total duration of the shake animation
            let numberOfShakes = 3 // Total number of shakes
            let initialAngle: Double = 10 // Initial rotation angle
            
            withAnimation(.easeInOut(duration: totalDuration / 2)) {
                self.shakeZoom = 0.95
                DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration / 2) {
                    withAnimation(.easeInOut(duration: totalDuration / 2)) {
                        self.shakeZoom = 0.9
                    }
                }
            }

            for i in 0..<numberOfShakes {
                let delay = (totalDuration / Double(numberOfShakes)) * Double(i)
                let angle = initialAngle - (initialAngle / Double(numberOfShakes)) * Double(i)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(Animation.easeInOut(duration: totalDuration / Double(numberOfShakes * 2))) {
                        self.shakeDegrees = angle
                    }
                    withAnimation(Animation.easeInOut(duration: totalDuration / Double(numberOfShakes * 2)).delay(totalDuration / Double(numberOfShakes * 2))) {
                        self.shakeDegrees = -angle
                    }
                }
            }

            // Stop the shaking and reset to 0
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                withAnimation {
                    self.shakeDegrees = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    startShaking()
                }
            }
        }
    
    
    struct PurchaseFeatureView: View {
        
        let title: String
        let desc: String
        let icon: String
        let color: Color
        
        var body: some View {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18, alignment: .top)
                .clipped()
                .foregroundColor(color)
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.callout)
                    Text(desc)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
        }
    }

    func toLocalCurrencyString(_ value: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        //formatter.locale = locale
        return formatter.string(from: NSNumber(value: value))
    }

}

#Preview {
    PurchaseView(isPresented: .constant(true))
}
