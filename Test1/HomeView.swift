//
//  HomeView.swift
//  Test1
//
//  Created by carl on 12/1/24.
//

import SwiftUI

// First Tab View
struct HomeView: View {
    @State private var userInput: String = ""
    @State private var items: [String] = [] // List to store user input
    @State private var showError: Bool = false // To track whether the error message should be shown
    @State private var showDisabledError: Bool = false // Show error for disabled button
    @State private var selectedItem: String? = nil // Store the randomly picked item
    @State private var navigateToResult: Bool = false // Control navigation explicitly
    @State private var errorCooldownActive: Bool = false // Prevent re-triggering error

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    Spacer().frame(height: 30)
                    
                    Image(systemName: "vision.pro")
                        .imageScale(.large)
                        .font(.system(size: 50))
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                        .padding()
                    
                    TextField("What do you want me to help you decide?", text: $userInput)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding()
                        .padding() // Add internal padding for text
                        .frame(height: 50) // Set the height
                        .background(Color(.systemGray6)) // Add a background color
                        .cornerRadius(8) // Round the corners
                        .padding()
                    
                    Spacer().frame(height: 20)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            if items.isEmpty {
                                triggerNotificationFeedback(type: .error) // Error feedback
                                
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
                                triggerNotificationFeedback(type: .success)
                                
                                selectedItem = items.randomElement() // Pick a random item
                                navigateToResult = true // Trigger navigation
                                items = []
                            }
                        }) {
                            Text("Help Me Decide")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(items.isEmpty ? Color.gray : Color.blue) // Gray out if no items
                                .cornerRadius(8)
                        }

                        // Add to List Button
                        Button(action: {
                            if !userInput.isEmpty {
                                if items.contains(userInput) {
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
                                    
                                    items.append(userInput) // Add user input to the list
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
                    
                    if !items.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Your Items:")
                                .font(.headline)
                            ForEach(items, id: \.self) { item in
                                Text("• \(item)")
                            }
                        }
                        .padding()
                    }
                    
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Random Draw")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $navigateToResult) {
                SelectionPageView(selectedItem: selectedItem)
            }
        }
        .overlay(
            GeometryReader { geometry in
                VStack {
                    Spacer()
                        .frame(height: geometry.size.height - 70)
                    
                    // Existing error message for duplicate items
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
                                    withAnimation {
                                        showError = false
                                    }
                                }
                            }
                    }
                    
                    // New error message for disabled button
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
                                    withAnimation {
                                        showDisabledError = false
                                    }
                                }
                            }
                    }
                }
                .ignoresSafeArea(edges: .horizontal)
            }
        )
    }
}
