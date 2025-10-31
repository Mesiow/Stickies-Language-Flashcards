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
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = nil
        appearance.backgroundColor = .clear
        
        // Large navigation title (e.g. "Languages")
        appearance.largeTitleTextAttributes = [
            .font: UIFont.rounded(ofSize: 34, weight: .bold)
        ]
        
        // Inline navigation title (smaller)
        appearance.titleTextAttributes = [
            .font: UIFont.rounded(ofSize: 17, weight: .semibold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(.light) //app is designed for light mode only (looks better)
                .environmentObject(homeViewModel)
                .environmentObject(navigationModel)
                .environment(\.font, .system(.body, design: .rounded))
        }
        .modelContainer(container)
    }
}
