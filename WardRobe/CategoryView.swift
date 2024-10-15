//
//  CategoryView.swift
//  WardRobe
//
//  Created by Kunwar Vats on 15/10/24.
//

import SwiftUI

// View for horizontally scrolling text elements
struct HorizontalScrollView: View {
    let items: [String]
    @State private var selectedText: String? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1) // Light gray border
                        )
                        .onTapGesture {
                            // Handle tap action
                            selectedText = item
                            print("Selected item: \(item)")
                        }
                }
            }
            .padding(.horizontal, 20) // Padding for horizontal scrolling
        }
    }
}
