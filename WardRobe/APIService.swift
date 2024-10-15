//
//  APIService.swift
//  WardRobe
//
//  Created by Kunwar Vats on 15/10/24.
//

import Foundation
import Combine

class ApiService: ObservableObject {
    @Published var items: [String] = []
    var cancellables = Set<AnyCancellable>()
    
    func fetchItems() {
        guard let url = URL(string: API_endpoints.categories.rawValue) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [String].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break // Handle successful completion
                case .failure(let error):
                    print("Error fetching items: \(error)")
                }
            }, receiveValue: { [weak self] items in
                self?.items = items
            })
            .store(in: &cancellables)
    }
}
