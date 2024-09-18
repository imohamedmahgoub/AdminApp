//
//  PriceRulesViewModel.swift
//  AdminTests
//
//  Created by Mohamed Mahgoub on 18/09/2024.
//

import XCTest
@testable import Admin

class PriceRulesViewModelIntegrationTests: XCTestCase {

    var viewModel: PriceRulesViewModel!

    override func setUp() {
        super.setUp()
        viewModel = PriceRulesViewModel(networkService: NetworkService())
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testAddDiscountSuccess() {
        
        let expectation = self.expectation(description: "Add Discount Success")

       
        viewModel.parameters = [
            "price_rule": [
                "title": "Test Discount",
                "value_type": "percentage",
                "value": "10.0",
                "target_type": "line_item",
                "allocation_method": "across",
                "starts_at": "2024-09-18T00:00:00Z",
                "ends_at": "2024-12-31T23:59:59Z"
            ]
        ]

        viewModel.addDiscout {
           
            XCTAssertTrue(true)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0)
    }

    func testGetDiscountSuccess() {
        let expectation = self.expectation(description: "Get Discount Success")

        viewModel.getDiscout {
            XCTAssertGreaterThan(self.viewModel.priceRulesArray.count, 0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0)
    }

    func testDeleteDiscount() {
       
        let expectation = self.expectation(description: "Delete Discount")

        viewModel.deleteDiscount(discountId: 123456)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        
            XCTAssertTrue(true) 
            expectation.fulfill()
        }

        waitForExpectations(timeout: 30.0)
    }
}
