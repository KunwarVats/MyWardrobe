//
//  WardrobeItemView.swift
//  WardRobe
//
//  Created by Kunwar Vats on 15/10/24.
//

import SwiftUI

// Custom view for each cell
struct WardRobeItemView: View {

    let product: Product

    var body: some View {
        VStack {
            // Top view with light gray background for the image
            ZStack {
                // Light gray background
                Color.gray.opacity(0.3)
                    .frame(minWidth: 100, idealWidth: .infinity, maxWidth: .infinity, minHeight: 100, alignment: .leading)
                
                // Image view
                Image(uiImage: UIImage(data: product.imageData!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding() // Padding around the image
            }
            
            // Bottom view with white background and text
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name ?? "")
                    .font(.headline)
                    .padding(.leading, 10) // Left alignment with padding
                Text(product.category ?? "")
                    .font(.subheadline)
                    .padding(.leading, 10) // Left alignment with padding
            }
            .padding()
            .background(Color.white)
        }
        .padding(.horizontal, 5) // Padding for each ItemView in the grid
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1)) // Light gray border for the complete cell
        .clipped()
    }
 }
