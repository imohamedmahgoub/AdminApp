//
//  Network Manage.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 02/09/2024.
//

import Foundation

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://3f133b6d41a2c070d75f3a1e1dc67b18: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@nciost1.myshopify.com"
    
    // MARK: - Create (POST)
    func createProduct(product: ProductResponse, completion: @escaping (Result<ProductResponse, Error>) -> Void) {
        let url = "\(baseURL)"
        let parameters = [
            "name": product.products.first?.title ?? "",
            "description": product.products.first?.bodyHTML ?? "",
            "price": product.products.first?.variants.first?.price ?? 0,
        ] as [String : Any]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: ProductResponse.self) { response in
                switch response.result {
                case .success(let product):
                    completion(.success(product))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - Read (GET)
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        let url = "\(baseURL)/admin/api/2024-07/products.json"
        print(url)
        AF.request(url, method: .get)
            .responseDecodable(of: ProductResponse.self) { response in
                switch response.result {
                case .success(let products):
                    completion(.success(products.products))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - Update (PUT)
    func updateProduct(product: ProductResponse, completion: @escaping (Result<ProductResponse, Error>) -> Void) {
        guard let id = product.products.first?.id else { return }
        let url = "\(baseURL)/products/\(id)"
        let parameters = [
            "name": product.products.first?.title ?? "",
            "description": product.products.first?.bodyHTML ?? "",
            "price": product.products.first?.variants.first?.price ?? 0,
        ] as [String : Any]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: ProductResponse.self) { response in
                switch response.result {
                case .success(let updatedProduct):
                    completion(.success(updatedProduct))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - Delete (DELETE)
    func deleteProduct(productId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/products/\(productId)"
        
        AF.request(url, method: .delete)
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

