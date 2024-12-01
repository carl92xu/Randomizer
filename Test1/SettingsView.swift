//
//  SettingsView.swift
//  Test1
//
//  Created by carl on 12/1/24.
//

import SwiftUI

// Third Tab View
struct SettingsView: View {
    @EnvironmentObject var globalItems: GlobalItemsManager
    @EnvironmentObject var globalAccent: GlobalAccentManager
    
    private let predefinedColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink, .gray, .primary]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer().frame(height: 1)

                    // Haptic Strength Section
                    Text("Haptic Strength")
                        .font(.headline)
//                        .padding(.leading)

                    Picker("Haptic Style", selection: $globalItems.hapticStyle) {
                        Text("Light").tag(UIImpactFeedbackGenerator.FeedbackStyle.light)
                        Text("Medium").tag(UIImpactFeedbackGenerator.FeedbackStyle.medium)
                        Text("Heavy").tag(UIImpactFeedbackGenerator.FeedbackStyle.heavy)
                    }
                    .pickerStyle(SegmentedPickerStyle())
//                    .padding(.horizontal)
                    .onChange(of: globalItems.hapticStyle) {
                        triggerHapticFeedback()
                    }

                    Spacer().frame(height: 1)

                    // Accent Color Section
                    Text("Accent Color")
                        .font(.headline)
//                        .padding(.leading)

                    VStack(alignment: .leading, spacing: 10) {

                        // Predefined Color Palette
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
                            ForEach(predefinedColors, id: \.self) { color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(globalAccent.accentColor == color ? Color.primary : Color.clear, lineWidth: 3)
                                    )
                                    .onTapGesture {
//                                        print("Tapped color: \(color)") // Debug: Log the selected color
                                        globalAccent.accentColor = color // Update the global accent color
                                    }
                            }
                            
                            // Custom ColorPicker Styled as a Circle
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(globalAccent.accentColor) // Show the selected color
                                    .frame(width: 40, height: 40) // Set desired size
                                    .overlay(
                                        Circle()
                                            .strokeBorder(
                                                AngularGradient(
                                                    gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red]),
                                                    center: .center
                                                ),
                                                lineWidth: 4
                                            )
                                    )
                                    .overlay(
                                        // Make the ColorPicker interactive and styled
                                        ColorPicker("", selection: $globalAccent.accentColor)
                                            .labelsHidden() // Hide default label
                                            .frame(width: 40, height: 40)
                                            .blendMode(.destinationOver) // Ensure the color fill is visible
                                    )
                                Spacer()
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(Color(.systemGray6)) // Add a light gray background
                    .cornerRadius(10) // Round the corners of the background
//                    .shadow(radius: 5) // Optional: Add a shadow for depth
                    
                    Spacer() // Optional: Add spacer for better layout at the bottom
                }
                .padding(.vertical)
            }
            .padding(.horizontal, 20)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
