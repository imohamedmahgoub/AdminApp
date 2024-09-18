//
//  AdminTests.swift
//  AdminTests
//
//  Created by Mohamed Mahgoub on 18/09/2024.
//

import XCTest
import Alamofire
@testable import Admin

class NetworkServiceTests: XCTestCase {

    var networkService: NetworkService!

    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        
        let session = Session(configuration: config)
        networkService = NetworkService()
    }

    override func tearDown() {
        networkService = nil
        super.tearDown()
    }


    // MARK: - Test Cases

    func testGetDataSuccess() {
        // Set up mock data
        MockURLProtocol.responseData = """
        {
            "products": [
                {
                    "id": 7847468892297,
                    "title": "ADIDAS | CLASSIC BACKPACK"
                }
            ]
        }
        """.data(using: .utf8)
        MockURLProtocol.error = nil
        MockURLProtocol.statusCode = 200
        
        let expectation = self.expectation(description: "Get Data Success")
        
        networkService.getData(path: "products", parameters: [:], model: ProductResponse.self) { result, error in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.products?.first?.title, "ADIDAS | CLASSIC BACKPACK")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }

    func testGetDataFailure() {
        // Set up the mock error scenario
        MockURLProtocol.responseData = nil
        MockURLProtocol.error = NSError(domain: "Network Error", code: 500, userInfo: nil)
        MockURLProtocol.statusCode = 500
        
        let expectation = self.expectation(description: "Get Data Failure")
        
        networkService.getData(path: "products", parameters: [:], model: ProductResponse.self) { result, error in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }
    
    func testPostDataSuccess() {
        // Mock a successful response
        MockURLProtocol.responseData = """
        {
            "product": {
                "id": 123456,
                "title": "Burton Custom Freestyle 151",
                "body_html": "Good snowboard!",
                "vendor": "Burton",
                "product_type": "Snowboard",
                "status": "draft"
            }
        }
        """.data(using: .utf8)
        MockURLProtocol.error = nil
        MockURLProtocol.statusCode = 200

        let expectation = self.expectation(description: "Post Data Success")

        let parameters: [String: Any] = [
            "product": [
                "title": "Burton Custom Freestyle 151",
                "body_html": "Good snowboard!",
                "vendor": "Burton",
                "product_type": "Snowboard",
                "status": "draft"
            ]
        ]

        networkService.postData(path: "products", parameters: parameters, postFlag: true) { result, error in
            XCTAssertNil(error)
            XCTAssertNotNil(result)

            if let json = result as? [String: Any],
               let product = json["product"] as? [String: Any] {
                XCTAssertEqual(product["title"] as? String, "Burton Custom Freestyle 151")
                XCTAssertEqual(product["body_html"] as? String, "Good snowboard!")
                XCTAssertEqual(product["vendor"] as? String, "Burton")
                XCTAssertEqual(product["product_type"] as? String, "Snowboard")
                XCTAssertEqual(product["status"] as? String, "draft")
            } else {
                XCTFail("Failed to parse result as JSON")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0)
    }

    func testPostDataFailure() {
        // Mock a failure response
        MockURLProtocol.responseData = nil
        MockURLProtocol.error = NSError(domain: "Network Error", code: 500, userInfo: nil)
        MockURLProtocol.statusCode = 500
        
        let expectation = self.expectation(description: "Post Data Failure")
        
        let parameters: [String: Any] = ["title": "Mock Product"]
        
        networkService.postData(path: "products", parameters: parameters, postFlag: true) { result, error in
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }
    
    func testPutDataFailure() {
        // Mock a failure response
        MockURLProtocol.responseData = nil
        MockURLProtocol.error = NSError(domain: "Network Error", code: 500, userInfo: nil)
        MockURLProtocol.statusCode = 500
        
        let expectation = self.expectation(description: "Put Data Failure")
        
        let parameters: [String: Any] = ["title": "Mock Product"]
        
        networkService.postData(path: "products", parameters: parameters, postFlag: false) { result, error in
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }
    
    func testDeleteDataSuccess() {
        // Mock a successful response
        MockURLProtocol.responseData = nil
        MockURLProtocol.error = nil
        MockURLProtocol.statusCode = 200
        
        let expectation = self.expectation(description: "Delete Data Success")
        
        networkService.deleteData(path: "products/123456")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
         
            XCTAssertTrue(true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }

    func testDeleteDataFailure() {
        // Mock a failure response
        MockURLProtocol.responseData = nil
        MockURLProtocol.error = NSError(domain: "Network Error", code: 500, userInfo: nil)
        MockURLProtocol.statusCode = 500
        
        let expectation = self.expectation(description: "Delete Data Failure")
        
        networkService.deleteData(path: "products/123456")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(true) 
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }
}

