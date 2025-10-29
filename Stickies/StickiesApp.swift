//
//  StickiesApp.swift
//  Stickies
//
//  Created by Chris W on 10/28/25.
//

import SwiftUI
import SwiftData

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
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(.light) //app is designed for light mode only (looks better)
                .environmentObject(homeViewModel)
                .environmentObject(navigationModel)
        }
        .modelContainer(container)
    }
}
