//
//  ContentView.swift
//  Test1
//
//  Created by carl on 11/30/24.
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
    var body: some View {
        NavigationStack { // Wrap HomeView content in NavigationStack
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .font(.system(size: 50))
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                Text("Text1")
                    .padding()
                NavigationLink(destination: NewPageView()) { // This will now navigate properly
                    Text("Go to New Page")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                Text("Text2")
                    .background(Color.blue)
            }
        }
    }
}

// Second Tab View
struct SecondTabView: View {
    var body: some View {
        VStack {
            Text("Text2")
                .font(.largeTitle)
                .foregroundStyle(.tint)
                .padding(.bottom, 50.0)
            Text("Text3")
                .background(Color.red)
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
    var body: some View {
        VStack {
            Text("This is the new page!")
                .font(.largeTitle)
                .padding()
            Image(systemName: "star.fill")
                .imageScale(.large)
                .foregroundStyle(.yellow)
                .padding()
        }
        .navigationTitle("New Page")
        .navigationBarTitleDisplayMode(.inline)
    }
}
