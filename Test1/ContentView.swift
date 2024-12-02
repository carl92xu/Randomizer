//
//  ContentView.swift
//  Test1
//
//  Created by Carl Xu on 11/30/24.
//

import SwiftUI

// Global variables
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


// UIApplication extension for dismissing the keyboard
extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


// Error popups
struct ErrorOverlayView: View {
    let showError: Bool
    let showDisabledError: Bool
    let dismissError: () -> Void // Callback to handle dismissal of errors
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                    .frame(height: geometry.size.height - 70)
                
                // Duplicate item error
                if showError {
                    Text("Item is Already in the List")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 50)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                dismissError()
                            }
                        }
                }
                
                // No item added error
                if showDisabledError {
                    Text("No Item has been Added")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 50)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                dismissError()
                            }
                        }
                }
            }
            .ignoresSafeArea(edges: .horizontal)
        }
    }
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
    @State private var isLandscape: Bool = false

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height

            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(1)

                InfinityView()
                    .tabItem {
                        Label("Infinity", systemImage: "infinity")
                    }
                    .tag(2)

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(3)

                MapsView()
                    .tabItem {
                        Label("Maps", systemImage: "map")
                    }
                    .tag(4)
            }
//            .toolbar {
//                if !isLandscape {
//                    ToolbarItem(placement: .bottomBar) {
//                        HStack {
//                            Spacer()
//                            Text("Toolbar visible in portrait mode")
//                            Spacer()
//                        }
//                    }
//                }
//            }
        }
        .environmentObject(globalItems)
        .environmentObject(globalAccent)
        .accentColor(globalAccent.accentColor)
    }
}


#Preview {
    ContentView()
        .environmentObject(GlobalItemsManager())
        .environmentObject(GlobalAccentManager())
}
