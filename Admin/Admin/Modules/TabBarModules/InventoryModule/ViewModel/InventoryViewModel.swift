//
//  InventoryViewModel.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 08/09/2024.
//

import Foundation

class InventoryViewModel {
    var networkService : NetworkServiceProtocol?
    var locationsArray : [Location] = []
    func getLocationData(completion: @escaping () -> Void){
        networkService = NetworkService()
        networkService?.getData(path: "locations", parameters: [:], model: LocationResponse.self, handler: { (response: LocationResponse?, error: Error?) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion()
            } else if let response = response {
                // print("Data received: \(response)")
                self.locationsArray = response.locations ?? []
                completion()
            }
        })
    }
}
