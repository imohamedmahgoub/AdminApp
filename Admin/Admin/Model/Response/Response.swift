//
//  Response.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 02/09/2024.
//

import Foundation

// MARK: - ProductResponse
struct ProductResponse: Codable {
    let products: [Product]?
}

// MARK: - Product
struct Product: Codable {
    let id: Int?
    let title, bodyHTML, vendor: String?
    let productType: String?
    let createdAt: String?
    let handle: String?
    let updatedAt: String?
    let publishedAt: String?
    let publishedScope: String?
    let tags: String?
    let status: String?
    let adminGraphqlAPIID: String?
    let variants: [Variant]?
    let options: [Option]?
    let images: [Image]?
    let image: Image?

    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case createdAt = "created_at"
        case handle
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case publishedScope = "published_scope"
        case tags, status
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case variants, options, images, image
    }
}

// MARK: - Image
struct Image: Codable {
    let id: Int?
    let position, productID: Int?
    let createdAt, updatedAt: String?
    let adminGraphqlAPIID: String?
    let width, height: Int?
    let src: String?


    enum CodingKeys: String, CodingKey {
        case id, position
        case productID = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case width, height, src
    }
}

// MARK: - Option
struct Option: Codable {
    let id, productID: Int?
    let name: String?
    let position: Int?
    let values: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position, values
    }
}

// MARK: - Variant
struct Variant: Codable {
    let id, productID: Int?
    let title, price: String?
    let position: Int?
    let inventoryPolicy: String?
    let compareAtPrice: String?
    let option1: String?
    let option2: String?
    let createdAt, updatedAt: String?
    let taxable: Bool?
    let fulfillmentService: String?
    let grams: Int?
    let inventoryManagement: String?
    let requiresShipping: Bool?
    let sku: String?
    let weight: Int?
    let weightUnit: String?
    let inventoryItemID, inventoryQuantity, oldInventoryQuantity: Int?
    let adminGraphqlAPIID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price, position
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
        case option1, option2
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxable
        case fulfillmentService = "fulfillment_service"
        case grams
        case inventoryManagement = "inventory_management"
        case requiresShipping = "requires_shipping"
        case sku, weight
        case weightUnit = "weight_unit"
        case inventoryItemID = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}
