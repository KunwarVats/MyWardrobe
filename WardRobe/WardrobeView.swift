//
//  ContentView.swift
//  WardRobe
//
//  Created by Kunwar Vats on 15/10/24.
//

import SwiftUI

struct WardRobeView: View {
    
    
    let items = [Product]() //Array(1...20) // Sample data
    
    @State private var selectedItems: [String: [String]] = [:] // Dictionary to hold selected items for each horizontal item
    @State private var showFilterView = false
    @State private var showAddProductView = false // State variable for showing the add product view
    @State private var selectedTextItem: String? = nil
    @StateObject private var apiService = ApiService()
    @StateObject private var viewModel = ProductViewModel()

    var body: some View {
        ZStack { // Use ZStack to overlay the floating button on top of the main view
            VStack {
                // Horizontal Scroll View with text views
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(apiService.items, id: \.self) { item in
                            let itemSelectedItems = selectedItems[item] ?? [] // Get selected items for the current item
                            let backgroundColor = itemSelectedItems.isEmpty ? Color.white : Color.green.opacity(0.5) // Change background color based on selected items
                            
                            Text(item)
                                .padding()
                                .background(backgroundColor)
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedTextItem = item // Store the selected item
                                    showFilterView = true // Show the modal sheet
                                }
                        }
                    }
                    .padding(.horizontal, 20) // Adds padding to the left and right of the scrolling view
                }
                .onAppear {
                    apiService.fetchItems()
                    viewModel.fetchProducts()
                }
                .frame(height: 50) // Set a fixed height for the horizontal scroll view
                
                // Vertical List View using LazyVGrid
                ScrollView { // Added ScrollView for vertical scrolling
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(viewModel.products, id: \.self) { product in
                            WardRobeItemView(product: product)
                        }
                    }

                    .padding(.horizontal, 20) // Padding for the LazyVGrid
                    .padding(.bottom) // Add bottom padding if needed
                }
            }
            .padding(.bottom, 20) // Additional padding at the bottom of the VStack
            .sheet(isPresented: $showFilterView) {
                if selectedTextItem != nil {
                    // Present the custom view when tapped on horizontal scroll items
                    
                    FilterView(showSheet: $showFilterView, selectedItems: $selectedItems[selectedTextItem ?? ""], item: selectedTextItem ?? "")
                }
            }

            // Floating Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showAddProductView.toggle() // Show the add product view
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                            .background(Color.blue) // Light blue background
                            .foregroundColor(.white) // White plus icon
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $showAddProductView) {
                AddProductView() // Present the AddProductView
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WardRobeView()
    }
}
