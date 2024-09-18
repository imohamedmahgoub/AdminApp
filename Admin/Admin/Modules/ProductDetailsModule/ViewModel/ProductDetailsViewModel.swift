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
    var sizeArray : [Option] = []
    var colorArray : [Option] = []
    var timer: Timer?
    var index = 0
    var id = 0
    var variantId = 0
    var imageId = 0
    var ReloadCV : (()->Void) = {}
    var parameters: [String: Any] = [:]
    var quantityParameters: [String: Any] = [:]
    var variantParameters: [String:Any] = [:]
    init(networkService: NetworkServiceProtocol = NetworkService()) {
         self.networkService = networkService
     }
    
    func updateProduct(completion: @escaping () -> Void) {
        print(variantId)
        networkService?.postData(path:"variants/\(variantId)", parameters: parameters, postFlag: false, handler: { (response, error) in
            if let error = error {
                print("Error Upload data: \(error.localizedDescription)")
                completion()
            } else if response != nil {
               print("Success")
                completion()
            }
        })
    }
    func updateProductQuantity(completion: @escaping () -> Void) {
        networkService?.postData(path:"inventory_levels/set", parameters: quantityParameters, postFlag: true, handler: { (response, error) in
            if let error = error {
                print("Error Upload data: \(error.localizedDescription)")
                completion()
            } else if response != nil {
               print("Success")
                completion()
            }
        })
    }
    
    func addProductVariant(completion: @escaping () -> Void) {
        networkService?.postData(path:"products/\(id)/variants", parameters: variantParameters, postFlag: true, handler: { (response, error) in
            if let error = error {
                print("Error Upload data: \(error.localizedDescription)")
                completion()
            } else if response != nil {
               print("Success")
                completion()
            }
        })
    }
    
    func deleteImage() {
        networkService?.deleteData(path: "products/\(id)/images/\(imageId)")
    }
    
    func deleteVaiant(){
        networkService?.deleteData(path: "products/\(id)/variants/\(variantId)")
    }
}
