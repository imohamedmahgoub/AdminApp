//
//  Network Manage.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 02/09/2024.
//

//import Foundation
//
//import Alamofire
//
////class NetworkManager {
//    static let shared = NetworkManager()
//    private let baseURL = "https://3f133b6d41a2c070d75f3a1e1dc67b18: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@nciost1.myshopify.com"
//    
//    // MARK: - Create (POST)
////    func createProduct(product: ProductResponse, completion: @escaping (Result<ProductResponse, Error>) -> Void) {
////        let url = "\(baseURL)"
////        let parameters = [
////            "name": product.products.first?.title ?? "",
////            "description": product.products.first?.bodyHTML ?? "",
////            "price": product.products.first?.variants.first?.price ?? 0,
////        ] as [String : Any]
////        
////        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
////            .responseDecodable(of: ProductResponse.self) { response in
////                switch response.result {
////                case .success(let product):
////                    completion(.success(product))
////                case .failure(let error):
////                    completion(.failure(error))
////                }
////            }
////    }
//    
//    // MARK: - Read (GET)
//    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
//        let url = "\(baseURL)/admin/api/2024-07/products.json"
//        print(url)
//        AF.request(url, method: .get)
//            .responseDecodable(of: ProductResponse.self) { response in
//                switch response.result {
//                case .success(let products):
//                    completion(.success(products.products))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//    }
//    
//    // MARK: - Update (PUT)
////    func updateProduct(product: ProductResponse, completion: @escaping (Result<ProductResponse, Error>) -> Void) {
////        guard let id = product.products.first?.id else { return }
////        let url = "\(baseURL)/products/\(id)"
////        let parameters = [
////            "name": product.products.first?.title ?? "",
////            "description": product.products.first?.bodyHTML ?? "",
////            "price": product.products.first?.variants.first?.price ?? 0,
////        ] as [String : Any]
////        
////        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
////            .responseDecodable(of: ProductResponse.self) { response in
////                switch response.result {
////                case .success(let updatedProduct):
////                    completion(.success(updatedProduct))
////                case .failure(let error):
////                    completion(.failure(error))
////                }
////            }
////    }
//    
//    // MARK: - Delete (DELETE)
////    func deleteProduct(productId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
////        let url = "\(baseURL)/products/\(productId)"
////        
////        AF.request(url, method: .delete)
////            .response { response in
////                switch response.result {
////                case .success:
////                    completion(.success(()))
////                case .failure(let error):
////                    completion(.failure(error))
////                }
////            }
////    }
//}
import Foundation
import Alamofire
protocol NetworkServiceProtocol{
    func getData<T: Codable> (path: String, parameters: Alamofire.Parameters, model: T.Type, handler: @escaping (T?,Error?) -> Void)
    func postData(path: String, parameters: Alamofire.Parameters, postFlag: Bool, handler: @escaping (Any?,Error?) -> Void)
    func deleteData(path: String)
}

class NetworkService: NetworkServiceProtocol{
 
    private let baseUrl = "https://nciost1.myshopify.com/admin/api/2024-07/"
    
    private let headers1: HTTPHeaders = [
        "X-Shopify-Access-Token": "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"
    ]
    
    private let headers: HTTPHeaders = [
        "X-Shopify-Access-Token": "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",
        "Content-Type": "application/json"
    ]
    
    func getData<T: Codable> (path: String, parameters: Alamofire.Parameters, model: T.Type, handler: @escaping (T?, Error?) -> Void){
        
        AF.request("\(baseUrl)\(path).json",parameters: parameters, headers: headers1).validate().responseDecodable(of: model.self) { response in
            switch response.result {
            case .success(let data):
                handler(data,nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                handler(nil,error)
            }
        }
    }
    
    func postData(path: String, parameters: Alamofire.Parameters, postFlag: Bool , handler: @escaping (Any?, Error?) -> Void){
        
        AF.request("\(baseUrl)\(path).json",method: postFlag ? .post : .put, parameters: parameters, encoding: JSONEncoding.default , headers: headers).validate().responseData { response in
            switch response.result{
            case .success(let data):
                do{
                    let result = try JSONSerialization.jsonObject(with: data, options: [])
                    handler(result,nil)
                }catch{
                    print(error.localizedDescription)
                    handler(nil,error)
                }
            case .failure(let error):
                print(error.localizedDescription)
                handler(nil,error)
            }
        }
    }
    func deleteData(path: String) {
    }
    
    
}


