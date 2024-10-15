//
//  LocalServicers.swift
//  WardRobe
//
//  Created by Kunwar Vats on 15/10/24.
//

import CoreData
import Foundation

class ProductService {
    private let context: NSManagedObjectContext

    // Initialize with the Core Data context
    init() {
        self.context = PersistenceController.shared.container.viewContext
    }

    // Fetch all products from Core Data
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()

        do {
            let products = try context.fetch(fetchRequest)
            completion(.success(products))
        } catch {
            print("Failed to fetch products: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}
