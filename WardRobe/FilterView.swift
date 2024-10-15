//
//  FilterVIew.swift
//  WardRobe
//
//  Created by Kunwar Vats on 15/10/24.
//
import SwiftUI

struct FilterView: View {
    @Binding var showSheet: Bool
    @Binding var selectedItems: [String]?
    let options = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
    var item: String // The text item that was selected

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(options, id: \.self) { option in
                        HStack {
                            Image(selectedItems?.contains(option) == true ? "checkbox" : "unchecked") // Use a proper image for checked and unchecked
                                .resizable()
                                .frame(width: 30, height: 30)
                                .border(.gray, width: 1.0)
                            
                            Text(option) // Show the option text
                                .padding(.leading, 10)
                        }
                        .onTapGesture {
                            if let selectedItems = selectedItems {
                                if selectedItems.contains(option) {
                                    self.selectedItems?.removeAll(where: { $0 == option }) // Remove if already selected
                                } else {
                                    self.selectedItems?.append(option) // Add to selected
                                }
                            } else {
                                selectedItems = [option] // Initialize if nil
                            }
                        }
                    }
                }
                Spacer()

                // Buttons at the bottom
                HStack {
                    Button("Reset") {
                        // Reset action
                        selectedItems?.removeAll()
                        showSheet = false
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(Color.red.opacity(0.3))
                    .cornerRadius(8)

                    Button("Apply") {
                        // Apply action
                        // Handle apply logic here
                        showSheet = false
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.3))
                    .cornerRadius(8)
                }
                .padding([.horizontal, .bottom], 20)
            }
            .navigationBarItems(leading: Button("Close") {
                showSheet = false
            })
            .navigationTitle(item)
        }
    }
}
