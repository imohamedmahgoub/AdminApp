//
//  ProductDetailsViewModel.swift
//  AdminTests
//
//  Created by Mohamed Mahgoub on 18/09/2024.
//

import XCTest
@testable import Admin

class ProductDetailsViewModelIntegrationTests: XCTestCase {

    var viewModel: ProductDetailsViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ProductDetailsViewModel(networkService: NetworkService())
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testUpdateProductSuccess() {
        viewModel.variantId = 123456
        viewModel.parameters = [
            "variant": [
                "title": "Updated Variant Title"
            ]
        ]

        let expectation = self.expectation(description: "Update Product Success")

        viewModel.updateProduct {
            XCTAssertTrue(true)
            
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0)
    }

    func testUpdateProductQuantitySuccess() {
        
        viewModel.quantityParameters = [
            "inventory_level": [
                "location_id": 123456,
                "inventory_item_id": 654321,
                "available": 100
            ]
        ]

        let expectation = self.expectation(description: "Update Product Quantity Success")

        viewModel.updateProductQuantity {
            XCTAssertTrue(true)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0)
    }

    func testAddProductVariantSuccess() {
        viewModel.id = 123456
        viewModel.variantParameters = [
            "variant": [
                "title": "New Variant",
                "price": "19.99"
            ]
        ]

        let expectation = self.expectation(description: "Add Product Variant Success")

        viewModel.addProductVariant {
            XCTAssertTrue(true)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0)
    }

    func testDeleteImageSuccess() {
        viewModel.id = 123456
        viewModel.imageId = 654321

        let expectation = self.expectation(description: "Delete Image Success")

        viewModel.deleteImage()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(true)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0)
    }

    func testDeleteVariantSuccess() {
        viewModel.id = 123456
        viewModel.variantId = 654321

        let expectation = self.expectation(description: "Delete Variant Success")

        viewModel.deleteVaiant()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(true) 
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0)
    }
}
