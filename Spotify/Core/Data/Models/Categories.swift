//
//  Categories.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 31.03.2024.
//
//   let categories = try? JSONDecoder().decode(Categories.self, from: jsonData)

import Foundation

// MARK: - Categories
struct Categories: Codable {
		let categories: CategoriesClass?
}

// MARK: - CategoriesClass
struct CategoriesClass: Codable {
		let href: String?
		let limit: Int?
		let next: String?
		let offset: Int?
		let previous: String?
		let total: Int?
		let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
		let href: String?
		let icons: [Icon]?
		let id, name: String?
}

// MARK: - Icon
struct Icon: Codable {
		let url: String?
		let height, width: Int?
}
