//
//  ContentView.swift
//  Test1
//
//  Created by Carl Xu on 11/30/24.
//

import SwiftUI

class GlobalItemsManager: ObservableObject {
    @Published var items: [String] = []
    @Published var hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .medium
}

class GlobalAccentManager: ObservableObject {
    @Published var accentColor: Color = .blue {
        didSet {
            objectWillChange.send() // Notify views of changes
        }
    }
}

let globalItems = GlobalItemsManager() // Shared instance
let globalAccent = GlobalAccentManager() // Shared instance


// Helper function for haptic feedback
func triggerHapticFeedback() {
    let generator = UIImpactFeedbackGenerator(style: globalItems.hapticStyle)
    generator.impactOccurred()
}

func triggerNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(type)
}


struct ContentView: View {
    @EnvironmentObject var globalAccent: GlobalAccentManager // Access the shared instance  // Enable this line causes the preview to crash
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            InfinityView()
                .tabItem {
                    Label("Infinity", systemImage: "infinity")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .environmentObject(globalItems) // Provide globalItems to child views
        .environmentObject(globalAccent)
        .accentColor(globalAccent.accentColor) // Use the global accent color
    }
}

#Preview {
    ContentView()
        .environmentObject(GlobalItemsManager())
        .environmentObject(GlobalAccentManager())
}
