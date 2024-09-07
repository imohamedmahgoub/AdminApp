//
//  ProductsViewModel.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 03/09/2024.
//

import Foundation
class ProductsViewModel {
    var productArray : [Product] = []
    var vendor = ""
    var networkService : NetworkServiceProtocol?
    func getData(completion: @escaping () -> Void){
        networkService = NetworkService()
        networkService?.getData(path:"products", parameters: [:], model: ProductResponse.self) { (response: ProductResponse?, error: Error?) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion()
            } else if let response = response {
                 //print("Data received: \(response)")
                self.productArray = response.products ?? []
                self.productArray = self.productArray.filter{$0.vendor == self.vendor}
                completion()
            }
        }
    }
    
    func deleteProduct(productId : Int){
        networkService?.deleteData(path: "products/\(productId)")
    }
}
