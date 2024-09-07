//
//  Response.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 02/09/2024.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let productResponse = try? JSONDecoder().decode(ProductResponse.self, from: jsonData)

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
    let publishedScope: String?
    let tags: String?
    let status: String?
    let variants: [Variant]?
    let options: [Option]?
    let images: [Image]?
    let image: Image?

    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case publishedScope = "published_scope"
        case tags, status
        case variants, options, images, image
    }
}

// MARK: - Image
struct Image: Codable {
    let id: Int?
    let position, productID: Int?
    let src: String?

    enum CodingKeys: String, CodingKey {
        case id, position
        case productID = "product_id"
        case src
    }
}

// MARK: - Option
struct Option: Codable {
    let id, productID: Int?
    let name: Name?
    let position: Int?
    let values: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position, values
    }
}

enum Name: String, Codable {
    case color = "Color"
    case size = "Size"
    case title = "Title"
}

// MARK: - Variant
struct Variant: Codable {
    let id, productID: Int?
    let title, price: String?
    let position: Int?
    let option1: String?
    let option2: Option2?
    let inventoryItemID, inventoryQuantity, oldInventoryQuantity: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price, position
        case option1, option2
        case inventoryItemID = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
    }
}
enum Option2: String, Codable {
    case beige = "beige"
    case black = "black"
    case blue = "blue"
    case burgandy = "burgandy"
    case gray = "gray"
    case lightBrown = "light_brown"
    case red = "red"
    case white = "white"
    case yellow = "yellow"
}
