//
//  DataModel.swift
//  SmallcaseGatewayAssignment
//
//  Created by noor on 28/09/23.
//

import Foundation

// MARK: - Data
struct Data: Codable {
    let products: [Product]
    let total, skip, limit: Int
}

// MARK: - Product
struct Product: Codable {
    let id: Int
    let title, description: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand, category: String
    let thumbnail: String
    let images: [String]
}
