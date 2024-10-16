//
//  ProductForm.swift
//  WardRobe
//
//  Created by Kunwar Vats on 15/10/24.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var category: String = ""
    @State private var brandName: String = ""
    @State private var purchaseDate: Date = Date()
    @State private var selectedImage: Data? = nil
    @State private var showImagePicker = false

    // State for error messages
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    let updateList: () -> ()


    var body: some View {
        VStack(spacing: 0) { // Use a VStack to prevent overlap
            // Close Button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Close the view
                }) {
                    Image(systemName: "xmark") // Cross button icon
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer() // Push the close button to the left
            }
            
            // Title
            Text("Add Product")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding() // Padding around the title
            
            // Image Selection Banner
            VStack {
                HStack {
                    if let imageData = selectedImage, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200) // Set a fixed height for the image
                            .cornerRadius(10)
                            .padding()
                    } else {
                        Text("Select an Image")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    Spacer()
                }
                .background(Color.blue.opacity(0.3)) // Light blue background
                .onTapGesture {
                    showImagePicker.toggle() // Show image picker when tapped
                }
            }
            .padding(.bottom, 20) // Space between the banner and the form

            // Main Form
            Form {
                Section(header: Text("Product Details")) {
                    TextField("Name", text: $name)
                    TextField("Category", text: $category)
                    TextField("Brand Name", text: $brandName)
                    DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
                }
            }
            .padding(.bottom, 20) // Add some bottom padding to the form
            
            // Error Message Display
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Save Product Button
            Button(action: {
                if validateFields() {
                    saveProduct()
                } else {
                    showError = true // Show error message if validation fails
                }
            }) {
                Text("Save Product")
                    .font(.headline)
                    .foregroundColor(.white) // White font color
                    .frame(height: 50) // Set height for the button
                    .frame(maxWidth: .infinity) // Center align the button
                    .background(Color.blue) // Light blue background
                    .cornerRadius(10) // Corner radius
                    .padding(.horizontal, 20) // Horizontal padding
            }
            .padding(.bottom, 20) // Bottom padding for the button
            
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(imageData: $selectedImage)
        }
    }
    
    private func validateFields() -> Bool {
        if name.isEmpty {
            errorMessage = "Name cannot be empty."
            return false
        }
        if category.isEmpty {
            errorMessage = "Category cannot be empty."
            return false
        }
        if brandName.isEmpty {
            errorMessage = "Brand Name cannot be empty."
            return false
        }
        if selectedImage == nil {
            errorMessage = "Please select an image."
            return false
        }
        return true
    }

    private func saveProduct() {
        // Implement your save logic here
        print("Product saved with Name: \(name), Category: \(category), Brand: \(brandName), Purchase Date: \(purchaseDate)")
        let newProduct = Product(context: PersistenceController.shared.container.viewContext)
        newProduct.name = name
        newProduct.category = category
        newProduct.brand = brandName
        newProduct.purchaseDate = purchaseDate
        newProduct.imageData = selectedImage // Save the image data
        
        PersistenceController.shared.saveContext()
        updateList()
        presentationMode.wrappedValue.dismiss() // Dismiss the view after saving
    }
}

// ImagePicker to select an image from the photo library
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageData: Data?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let result = results.first else { return }

            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let image = image as? UIImage, let imageData = image.pngData() {
                        DispatchQueue.main.async {
                            self.parent.imageData = imageData
                        }
                    }
                }
            }
        }
    }
}
