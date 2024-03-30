//
//  AuthRepositoryProtocol.swift
//  Spotify
//
//  Created by Mariya Aliyeva on 16.03.2024.
//

import Foundation

protocol AuthRepositoryProtocol {
	func save(accessToken: String)
	func getAccessToken() -> String?
	func removeAccessToken()
	func save(refreshToken: String)
	func getRefreshToken() -> String?
	func removeRefreshToken()
	func removeAllTokens()
}
