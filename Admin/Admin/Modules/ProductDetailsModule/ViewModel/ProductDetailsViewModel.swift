//
//  ProductDetailsViewModel.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 05/09/2024.
//

import Foundation
class ProductDetailsViewModel {
    var networkService : NetworkServiceProtocol?
    var productArray : [Product] = []
    var imagesArray : [Image] = []
    var sizeArray : [String] = []
    var colorArray : [String] = []
    var timer: Timer?
    var index = 0
    var id = 0
    var variantId = 0
    var parameters: [String: Any] = [:]
    var quantityParameters: [String: Any] = [:]
    
    func updateProduct(completion: @escaping () -> Void) {
        networkService = NetworkService()
        print(variantId)
        networkService?.postData(path:"variants/\(variantId)", parameters: parameters, postFlag: false, handler: { (response, error) in
            if let error = error {
                print("Error Upload data: \(error.localizedDescription)")
                completion()
            } else if response != nil {
               //print("Data Uploaded : \(response)")
                completion()
            }
        })
    }
    func updateProductQuantity(completion: @escaping () -> Void) {
        networkService = NetworkService()
        print(variantId)
        networkService?.postData(path:"inventory_levels/set", parameters: quantityParameters, postFlag: true, handler: { (response, error) in
            if let error = error {
                print("Error Upload data: \(error.localizedDescription)")
                completion()
            } else if response != nil {
               //print("Data Uploaded : \(response)")
                completion()
            }
        })
    }
}
