//
//  AuthResponse.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 22.02.2024.
//

import Foundation

struct AuthResponse: Decodable {
	let accessToken: String
	let expiresIn: Int
	let refreshToken: String?
	let scope: String
	let tokenType: String
	
	enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case expiresIn = "expires_in"
		case refreshToken = "refresh_token"
		case scope
		case tokenType = "token_type"
	}
}
