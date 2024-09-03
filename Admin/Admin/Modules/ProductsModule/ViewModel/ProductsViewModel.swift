//
//  ProductsViewModel.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 03/09/2024.
//

import Foundation
class ProductsViewModel {
    var productArray : [Product] = []
    func getData(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchProducts { result in
            switch result {
            case .success(let products):
                self.productArray = products
                print(products)
                print(self.productArray.count)
                completion()
            case .failure(let error):
                print("Error fetching products: \(error)")
                completion()
            }
        }
    }
}
