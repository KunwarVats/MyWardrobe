//
//  ProductViewModel.swift
//  WardRobe
//
//  Created by Kunwar Vats on 15/10/24.
//

import Foundation
import SwiftUI

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    private let productService: ProductService

    init() {
        self.productService = ProductService()
        fetchProducts()
    }

    func fetchProducts() {
        productService.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self?.products = products
                }
            case .failure(let error):
                print("Error fetching products: \(error.localizedDescription)")
            }
        }
    }
}
