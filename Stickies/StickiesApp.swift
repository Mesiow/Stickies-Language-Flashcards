//
//  StickiesApp.swift
//  Stickies
//
//  Created by Chris W on 10/28/25.
//

import SwiftUI
import SwiftData

extension UIFont {
    static func rounded(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor
        return UIFont(descriptor: descriptor.withDesign(.rounded) ?? descriptor, size: size)
    }
}

@main
struct StickiesApp: App {
    
    let container: ModelContainer
    
    @StateObject private var homeViewModel: HomeViewModel
    @StateObject private var navigationModel = NavigationModel()
    @StateObject private var purchaseManager = PurchaseManager()
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showOnboarding = false
    @State private var showPaywall = false
    
    init(){
        let schema = Schema([
            Language.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            self.container = container
            
            _homeViewModel = StateObject(
                wrappedValue: HomeViewModel(context: container.mainContext)
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        
        initAppearance()
    }
    
    func initAppearance(){
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.rounded(ofSize: 34, weight: .bold)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.rounded(ofSize: 17, weight: .semibold)
        ]
        
        UINavigationBar.appearance().tintColor = .black
        UIBarButtonItem.appearance().tintColor = .black
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .tint(.black)
                .preferredColorScheme(.light) //app is designed for light mode only (looks better)
                .environmentObject(homeViewModel)
                .environmentObject(navigationModel)
                .environmentObject(purchaseManager)
                .environment(\.font, .system(.body, design: .rounded))
                .fullScreenCover(isPresented: $showPaywall) {
                    PurchaseView(isPresented: $showPaywall)
                        .background(AppInfo.backgroundColor)
                        .environmentObject(purchaseManager)
                }
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
        }
        .modelContainer(container)
    }
}
