//
//  Test1App.swift
//  Test1
//
//  Created by carl on 11/30/24.
//

import SwiftUI

@main
struct Test1App: App {
    let globalItems = GlobalItemsManager() // Instantiate the shared manager

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(globalItems) // Inject into the environment
        }
    }
}
