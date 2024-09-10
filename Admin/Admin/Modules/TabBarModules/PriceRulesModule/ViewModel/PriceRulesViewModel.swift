//
//  PriceRulesViewModel.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 10/09/2024.
//

import Foundation

class PriceRulesViewModel {
    var networkService : NetworkServiceProtocol?
    var priceRulesArray : [PriceRule] = []
    var parameters : [String:Any] = [:]
    
    func addDiscout(completion: @escaping () -> Void) {
        networkService?.postData(path: "price_rules", parameters: parameters, postFlag: true, handler: { (response, error) in
            if let error = error {
                print("Error Upload data: \(error.localizedDescription)")
                completion()
            } else if let response = response {
               print("Data Uploaded : \(response)")
                completion()
            }
        })
        
    }
    func getDiscout(completion: @escaping () -> Void) {
        networkService = NetworkService()
        networkService?.getData(path: "price_rules", parameters: [:], model: PriceRulesResponse.self, handler: { (response: PriceRulesResponse?, error: Error?) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion()
            } else if let response = response {
                 //print("Data received: \(response)")
                self.priceRulesArray = response.priceRules ?? []
                completion()
            }
        })
    }
    func deleteDiscount(discountId : Int) {
        networkService = NetworkService()
        networkService?.deleteData(path: "price_rules/\(discountId)")
    }
}
