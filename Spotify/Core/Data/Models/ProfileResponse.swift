//
//  ProfileResponse.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 05.03.2024.
//
//   let profileResponse = try? JSONDecoder().decode(ProfileResponse.self, from: jsonData)

import Foundation

// MARK: - ProfileResponse
struct ProfileResponse: Codable {
	let country, displayName, email: String?
	let id: String
	let images: [Image]?
	let product: String
	
	enum CodingKeys: String, CodingKey {
		case country
		case displayName = "display_name"
		case email
		case id, product, images
	}
}

// MARK: - Image
struct Image: Codable {
	let url: String
}
