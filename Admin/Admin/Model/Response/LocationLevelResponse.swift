//
//  LocationLevelResponse.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 09/09/2024.
//

import Foundation

// MARK: - LocationLevelResponse
struct LocationLevelResponse: Codable {
    let inventoryLevels: [InventoryLevel]?

    enum CodingKeys: String, CodingKey {
        case inventoryLevels = "inventory_levels"
    }
}

// MARK: - InventoryLevel
struct InventoryLevel: Codable {
    let inventoryItemID, locationID, available: Int?
    let updatedAt: String?
    let adminGraphqlAPIID: String?

    enum CodingKeys: String, CodingKey {
        case inventoryItemID = "inventory_item_id"
        case locationID = "location_id"
        case available
        case updatedAt = "updated_at"
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}

struct InventoryItem: Codable {
    
    var id: Int?
    var sku: String?
    var createdAt: String?
    var updatedAt: String?
    var requiresShipping: Bool?
    var tracked: Bool?
    var adminGraphqlApiId: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case sku = "sku"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case requiresShipping = "requires_shipping"
        case tracked = "tracked"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

