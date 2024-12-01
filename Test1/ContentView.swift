//
//  ContentView.swift
//  Test1
//
//  Created by Carl Xu on 11/30/24.
//

import SwiftUI

//var globalItems: [String] = []
class GlobalItemsManager: ObservableObject {
    @Published var items: [String] = []
}

let globalItems = GlobalItemsManager() // Shared instance


struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SecondTabView()
                .tabItem {
                    Label("Infinity", systemImage: "infinity")
                }
            
//            ThirdTabView()
//                .tabItem {
//                    Label("Third Tab", systemImage: "infinity.circle")
//                }
        }
        .environmentObject(globalItems) // Provide globalItems to child views
    }
}

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
                NewPageView(selectedItem: selectedItem)
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


// Second Tab View
struct SecondTabView: View {
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
                    
                    Spacer().frame(height: 30)
                    
                    Image(systemName: "infinity")
                        .imageScale(.large)
                        .font(.system(size: 60))
                        .foregroundStyle(.tint)
                    
                    Spacer().frame(height: 10)
                    
                    Text("Hello, world!")
                        .padding()
                    
                    Spacer().frame(height: 8)
                    
                    TextField("What do you want me to help you decide?", text: $userInput)
                        .padding() // Add internal padding for text
                        .frame(height: 50) // Set the height
                        .background(Color(.systemGray6)) // Add a background color
                        .cornerRadius(8) // Round the corners
                        .padding()
                    
                    Spacer().frame(height: 20)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            if globalItems.items.isEmpty {
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
            .navigationTitle("Draw Until Empty")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $navigateToResult) {
//                SelectionPageView2(selectedItem: selectedItem, items: globalItems.items)
                SelectionPageView2(selectedItem: selectedItem)
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


// Third Tab View
//struct ThirdTabView: View {
//    var body: some View {
//        Text("Third Tab Content")
//            .padding()
//    }
//}


// New Page View for Tab 1
struct NewPageView: View {
    var selectedItem: String?

    var body: some View {
        VStack {
            Image(systemName: "star.fill")
                .imageScale(.large)
                .foregroundStyle(.yellow)
                .padding()
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
            Spacer()
        }
        .padding(.horizontal, 20)
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct SelectionPageView2: View {
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


#Preview {
    ContentView()
}
