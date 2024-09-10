//
//  LocationResponse.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 08/09/2024.
//


import Foundation

// MARK: - LocationResponse
struct LocationResponse: Codable {
    let locations: [Location]?
}

// MARK: - Location
struct Location: Codable {
    let id: Int?
    let name: String?
    let address1, address2, city, zip: String?
    let province: String?
    let country: String?
    let phone: String?
    let createdAt, updatedAt: String?
    let countryCode, countryName: String?
    let provinceCode: String?
    let legacy, active: Bool?
    let adminGraphqlAPIID, localizedCountryName: String?
    let localizedProvinceName: String?

    enum CodingKeys: String, CodingKey {
        case id, name, address1, address2, city, zip, province, country, phone
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryCode = "country_code"
        case countryName = "country_name"
        case provinceCode = "province_code"
        case legacy, active
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case localizedCountryName = "localized_country_name"
        case localizedProvinceName = "localized_province_name"
    }
}
