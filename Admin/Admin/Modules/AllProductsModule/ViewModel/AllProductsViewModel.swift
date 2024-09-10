//
//  AllProductsViewModel.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 03/09/2024.
//

import Foundation
class AllProductsViewModel {
    var productArray : [Product] = []
    var locationsLevelArray : [InventoryLevel] = []
    var networkService : NetworkServiceProtocol?
    func getData(completion: @escaping () -> Void){
        networkService = NetworkService()
        networkService?.getData(path:"products", parameters: [:], model: ProductResponse.self) { (response: ProductResponse?, error: Error?) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion()
            } else if let response = response {
                // print("Data received: \(response)")
                self.productArray = response.products ?? []
                completion()
            }
        }
    }
    
    func deleteProduct(productId : Int){
        networkService?.deleteData(path: "products/\(productId)")
    }
    
    func getLocationLevelData(completion: @escaping () -> Void) {
        networkService?.getData(path: "inventory_levels.json?location_ids=72712781961", parameters: [:], model: LocationLevelResponse.self, handler: { (response: LocationLevelResponse?, error: Error?) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion()
            } else if let response = response {
               //  print("Data received: \(response)")
                self.locationsLevelArray = response.inventoryLevels ?? []
                completion()
            }
        })
    }
}
