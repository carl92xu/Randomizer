//
//  SelectionPageView.swift
//  Test1
//
//  Created by carl on 12/1/24.
//

import SwiftUI

// Selection Page View for Tab 1
struct SelectionPageView: View {
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
