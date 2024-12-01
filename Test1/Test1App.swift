//
//  Test1App.swift
//  Test1
//
//  Created by carl on 11/30/24.
//

import SwiftUI

@main
struct Test1App: App {
    @StateObject private var globalItems = GlobalItemsManager() // Shared instance

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(globalItems) // Inject globalItems into the environment
        }
    }
}
