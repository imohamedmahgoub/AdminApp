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
    var parameters: [String: Any] = [:]
    func updateProduct(completion: @escaping () -> Void) {
        networkService = NetworkService()
        networkService?.postData(path: "products", parameters: ["product":parameters], postFlag: false, handler: { (response, error) in
            if let error = error {
                print("Error Upload data: \(error.localizedDescription)")
                completion()
            } else if let response = response {
               print("Data Uploaded : \(response)")
                completion()
            }
        })
        
    }


}
