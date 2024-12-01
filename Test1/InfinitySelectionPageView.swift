//
//  InfinitySelectionPageView.swift
//  Test1
//
//  Created by carl on 12/1/24.
//

import SwiftUI

// Selection Page View for Tab 2
struct InfinitySelectionPageView: View {
    @State private var showDisabledError: Bool = false
    @State private var errorCooldownActive: Bool = false
    @State private var currentSelectedItem: String? = nil
//    @State private var remainingItems: [String]

    // Initialize with selectedItem and items
//    init(selectedItem: String?, items: [String]) {
//        self._currentSelectedItem = State(initialValue: selectedItem)
//        self._remainingItems = State(initialValue: globalItems.items)
//    }
    init(selectedItem: String?) {
        self._currentSelectedItem = State(initialValue: selectedItem)
//        self._remainingItems = State(initialValue: globalItems.items)
    }

    var body: some View {
        VStack {
            Image(systemName: "star.fill")
                .imageScale(.large)
                .foregroundStyle(.yellow)
                .padding()
            
            // Show current selected item
            if let item = currentSelectedItem {
                Text("Current Pick:")
                    .font(.headline)
                    .padding()
                Text(item)
                    .font(.largeTitle)
                    .bold()
                    .padding()
            } else {
                Text("No item was selected!")
                    .font(.headline)
                    .padding()
            }
            
            Spacer().frame(height: 20)
            
            // Button to pick the next item
            if !globalItems.items.isEmpty {
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
                        if globalItems.items.count == 1 {
                            triggerNotificationFeedback(type: .warning)
                        } else {
                            triggerHapticFeedback()
                        }
                                                    
                        // Pick a random item and remove it from the list
                        let randomIndex = Int.random(in: 0..<globalItems.items.count)
                        currentSelectedItem = globalItems.items[randomIndex]
                        globalItems.items.remove(at: randomIndex)
                    }
                }) {
                    Text("Next Pick")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(globalItems.items.isEmpty ? Color.gray : Color.blue) // Gray out if no items
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
            } else {
                Text("No More Items Left to Pick")
                    .padding()
////                Optional UI design for "No More Items Left to Pick"
//                GeometryReader { geometry in
//                    VStack {
//                        Spacer() // Push content to the bottom
//
//                        Text("No More Items Left to Pick")
//                            .font(.headline)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.gray.opacity(0.2)) // Optional background
//                            .cornerRadius(8)
//                            .padding(.horizontal, 20)
//                            .padding(.bottom, geometry.safeAreaInsets.bottom + 20) // Adjust for safe area
//
//                    }
//                    .ignoresSafeArea(edges: .bottom) // Ensure it doesn't overlap with the safe area
//                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            GeometryReader { geometry in
                VStack {
                    Spacer()
                        .frame(height: geometry.size.height - 70)
                                        
                    // Error message for disabled button
                    if showDisabledError {
                        Text("No Item Left to Pick")
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
