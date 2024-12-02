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


// Helper functions for haptic feedback
func triggerHapticFeedback() {
    let generator = UIImpactFeedbackGenerator(style: globalItems.hapticStyle)
    generator.impactOccurred()
}

func triggerNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(type)
}


// Custom TextField style to make touchable area bigger
struct TappableTextFieldStyle: TextFieldStyle {
    @FocusState private var textFieldFocused: Bool
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16) // Add internal padding for text
            .frame(height: 60) // Set the height
            .background(Color(.systemGray6)) // Add a background color
            .cornerRadius(8) // Round the corners
            .focused($textFieldFocused)
            .onTapGesture {
                textFieldFocused = true
            }
            .padding()  // External padding
    }
}


struct ContentView: View {
    @EnvironmentObject var globalAccent: GlobalAccentManager // Access the shared instance
    
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
