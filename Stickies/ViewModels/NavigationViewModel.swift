//
//  NavigationViewModel.swift
//  Paste Keyboard
//
//  Created by Chris W on 10/5/25.
//

import SwiftUI
import Combine

//Navigation path
enum Route: Hashable {
    case addLanguage
    case languageStickiesView(Language)
    case addNewSticky
}

enum PendingAction {
    case addLanguage
    case none
}

@MainActor
final class NavigationModel: ObservableObject {
    @Published var path: [Route] = []
    @Published var pendingAction: PendingAction = .none
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    //Navigates back one view
    func back(){
        path.removeLast()
    }
    
    //Should be used for when triggering a modal display from one of our navigation paths so that state can be reset without issues
    func pop(){
        path.removeLast()
    }
}

