//
//  InfinityView.swift
//  Test1
//
//  Created by carl on 12/1/24.
//

import SwiftUI

// Second Tab View
struct InfinityView: View {
    @EnvironmentObject var globalItems: GlobalItemsManager // Observe globalItems
    
    @State private var userInput: String = ""
//    @State private var items: [String] = [] // List to store user input
    @State private var showError: Bool = false // To track whether the error message should be shown
    @State private var showDisabledError: Bool = false // Show error for disabled button
    @State private var selectedItem: String? = nil // Store the randomly picked item
    @State private var navigateToResult: Bool = false // Control navigation explicitly
    @State private var errorCooldownActive: Bool = false // Prevent re-triggering error

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    Spacer().frame(height: 35)
                    
                    Image(systemName: "infinity")
                        .imageScale(.large)
                        .font(.system(size: 60))
                        .foregroundStyle(.tint)
                    
                    Spacer().frame(height: 30)
                    
                    Text("Hello, world!")
                        .padding()
                    
                    Spacer().frame(height: 8)
                    
                    TextField("What do you want me to help you decide?", text: $userInput)
                        .textFieldStyle(TappableTextFieldStyle())
                    
                    Spacer().frame(height: 20)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            if globalItems.items.isEmpty {
                                triggerNotificationFeedback(type: .error)
                                
                                if !errorCooldownActive {
                                    withAnimation {
                                        showDisabledError = true // Show error message
                                    }
                                    errorCooldownActive = true // Activate cooldown
                                    
                                    // Reset state after cooldown
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        withAnimation {
                                            showDisabledError = false
                                            errorCooldownActive = false
                                        }
                                    }
                                }
                            } else {
//                                selectedItem = globalItems.items.randomElement() // Pick a random item
                                triggerHapticFeedback()
                                
                                let randomIndex = Int.random(in: 0..<globalItems.items.count)
                                selectedItem = globalItems.items[randomIndex]
                                navigateToResult = true // Trigger navigation
                                
                                //*************************
                                globalItems.items.remove(at: randomIndex)
                                //*************************
                            }
                        }) {
                            Text("Help Me Decide")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(globalItems.items.isEmpty ? Color.gray : Color.blue) // Gray out if no globalItems
                                .cornerRadius(8)
                        }

                        // Add to List Button
                        Button(action: {
                            if !userInput.isEmpty {
                                if globalItems.items.contains(userInput) {
                                    triggerNotificationFeedback(type: .error)
                                    
                                    if !errorCooldownActive {
                                        withAnimation {
                                            showError = true // Show duplicate item error
                                        }
                                        errorCooldownActive = true // Activate cooldown
                                        
                                        // Reset state after cooldown
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            withAnimation {
                                                showError = false
                                                errorCooldownActive = false
                                            }
                                        }
                                    }
                                } else {
                                    triggerHapticFeedback()
                                    
                                    globalItems.items.append(userInput) // Add user input to the list
                                    showError = false
                                }
                                userInput = "" // Clear the text field
                            }
                        }) {
                            Text("Add to List")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if !globalItems.items.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Your Items:")
                                .font(.headline)
                            ForEach(globalItems.items, id: \.self) { item in
                                Text("• \(item)")
                            }
                        }
                        .padding()
                    }
                    
                }
                .frame(maxWidth: .infinity)
            }
            .onTapGesture {
                UIApplication.shared.dismissKeyboard()
            }
            .navigationTitle("Draw Until Empty")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $navigateToResult) {
                InfinitySelectionPageView(selectedItem: selectedItem)
            }
        }
        .overlay(
            ErrorOverlayView(
                showError: showError,
                showDisabledError: showDisabledError,
                dismissError: {
                    withAnimation {
                        showError = false
                        showDisabledError = false
                    }
                }
            )
        )
    }
}
