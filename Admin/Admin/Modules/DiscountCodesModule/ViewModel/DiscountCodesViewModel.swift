//
//  DiscountCodesViewModel.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 11/09/2024.
//

import Foundation

class DiscountCodesViewModel {
    var discountCodesArray : [DiscountCode] = []
    var networkService : NetworkServiceProtocol?
    var id = 0
    var parameters : [String:Any] = [:]
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
         self.networkService = networkService
     }
    func getDicountCodes(completion: @escaping () -> Void) {
        networkService?.getData(path: "price_rules/\(id)/discount_codes", parameters: [:], model: DiscountCodesResponse.self, handler: { (response: DiscountCodesResponse?, error: Error?) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion()
            } else if let response = response {
                print("Data received: \(response)")
                self.discountCodesArray = response.discountCodes ?? []
                completion()
            }
        })
    }
    
    func createAdiscountCode(completion: @escaping () -> Void){
        networkService?.postData(path: "price_rules/\(id)/discount_codes", parameters: parameters, postFlag: true, handler: { (response, error) in
            if let error = error {
                print("Error Upload data: \(error.localizedDescription)")
                completion()
            } else if response != nil {
               print("Success")
                completion()
            }
        })
    }
}
