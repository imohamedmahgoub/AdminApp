//
//  BrandsViewModel.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 02/09/2024.
//

import Foundation

class BrandsViewModel {
    var brandsArray : [SmartCollection] = []
    var networkService : NetworkServiceProtocol?
    func getData(completion: @escaping () -> Void){
        networkService = NetworkService()
        networkService?.getData(path:"smart_collections", parameters: [:], model: BrandsResponse.self) { (response: BrandsResponse?, error: Error?) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion()
            } else if let response = response {
                //print("Data received: \(response)")
                self.brandsArray = response.smartCollections ?? []
                completion()
            }
        }
    }
}


