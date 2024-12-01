//
//  ContentView.swift
//  Test1
//
//  Created by Carl Xu on 11/30/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SecondTabView()
                .tabItem {
                    Label("Second Tab", systemImage: "star")
                }
            
            ThirdTabView()
                .tabItem {
                    Label("Third Tab", systemImage: "square.and.pencil")
                }
        }
    }
}

// First Tab View
struct HomeView: View {
    
    @State private var userInput: String = ""
    @State private var items: [String] = [] // List to store user input
    @State private var showError: Bool = false // To track whether the error message should be shown
    @State private var selectedItem: String? = nil // Store the randomly picked item
    
    var body: some View {
        NavigationStack { // Wrap HomeView content in NavigationStack
            ScrollView {
                VStack {
                    
                    Spacer().frame(height: 30) // Adds space at the very top
                    
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .font(.system(size: 50))
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                        .padding()
                    
                    // TextField for user input
                    TextField("What do you want me to help you decide?", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Spacer().frame(height: 20)
                    
                    // Buttons side by side
                    HStack(spacing: 20) {
                        // NavigationLink Button
                        NavigationLink(destination: NewPageView()) {
                            Text("Help Me Decide")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .disabled(items.isEmpty)
                        .onTapGesture {
                            if !items.isEmpty {
                                selectedItem = items.randomElement() // Pick a random item
                            }
                        }

                        // Add to List Button
                        Button(action: {
                            if !userInput.isEmpty {
                                if items.contains(userInput) {
                                    // Show error popup
                                    withAnimation {
                                        showError = true
                                    }
                                } else {
                                    items.append(userInput) // Add user input to the list
                                    showError = false // Hide the error message
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
                        .padding(.horizontal, 20) // Adds padding on both sides
                    
                    // Displaying the list of items
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
                .frame(maxWidth: .infinity) // Expand to fill the entire width
                
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
        
        .overlay(
            GeometryReader { geometry in
                VStack {
                    Spacer()
                        .frame(height: geometry.size.height - 70) // Set the height of Spacer to the screen's height
                    if showError {
                        Text("Item is Already in the List")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                            .padding(.bottom, geometry.safeAreaInsets.bottom + 50) // Positioned above the tab bar
                            .transition(.opacity.combined(with: .move(edge: .bottom))) // Slide and fade in
                            .onAppear {
                                // Auto-hide after 2 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation {
                                        showError = false
                                    }
                                }
                            }
                    }
                }
                .ignoresSafeArea(edges: .horizontal) // Ensure it doesn't affect layout
            }
        )
//        .tabViewStyle(PageTabViewStyle())
        
    }
}


// Second Tab View
struct SecondTabView: View {
    var body: some View {
        VStack {
            Text("There is nothing to see here!")
                .font(.largeTitle)
                .foregroundStyle(.tint)
                .padding(.bottom, 50.0)
            Text("Jusy Some Random Text")
                .padding(10)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

// Third Tab View
struct ThirdTabView: View {
    var body: some View {
        Text("Third Tab Content")
            .padding()
    }
}

#Preview {
    ContentView()
}

struct NewPageView: View {
    var selectedItem: String?

    var body: some View {
        VStack {
            if let item = selectedItem {
                Text("You Should Pick:")
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
            Image(systemName: "star.fill")
                .imageScale(.large)
                .foregroundStyle(.yellow)
                .padding()
        }
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}
