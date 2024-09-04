//
//  AddProductViewModel.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 04/09/2024.
//

import Foundation

class AddProductViewModel {
    var networkService : NetworkServiceProtocol?
    var vendor = ""
    var parameters: [String: Any] = [:]
    func createProduct(completion: @escaping () -> Void) {
        networkService = NetworkService()
        networkService?.postData(path: "products", parameters: ["product":parameters], postFlag: true, handler: { (response, error) in
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
